//
//  DogCardFeatureTests.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import Testing
import ComposableArchitecture
import UIKit
import Photos
@testable import NiceDemo_SwiftUI

@MainActor
struct DogCardFeatureTests {
    // Dependencies
    let network = MockDogCardNetwork()
    let urlSession = MockDogCardURLSession()
    let photoLibraryService = MockDogCardPhotoLibraryInterface()
    
    @Test("For main mode, load random image url, download image data by url, set property of image, triggering reload of view")
    func onAppearMainMode() async {
        // given
        let imageURL = URL(string: "https://example.com/dog.jpg")!
        let response = GetRandomDogImageServerResponse(data: imageURL.absoluteString)
        network.response = response
        
        // stub image data for URLSession
        let image = UIImage(systemName: "star")!
        let imageData = image.pngData()!
        urlSession.data = imageData
        
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogCardFeature.State(dog: dog, mode: .main, isLoading: false)) {
            DogCardFeature()
        } withDependencies: {
            $0.dogCardNetwork = network
            $0.dogCardURLSession = urlSession
        }
        
        // when
        await store.send(.onAppear)
        await store.receive(\.loadRandomImage) {
            $0.isLoading = true
        }
        await store.receive(\.handleRandomImage.success)
        await store.receive(\.loadImage)
        await store.receive(\.imageDataLoaded) {
            $0.loadedImageData = imageData
            $0.isLoading = false
        }
        await store.finish()
        
        // then
        #expect(urlSession.fetchDataCalled == 1)
        #expect(network.getBreedRandomImageCalled == 1)
        #expect(store.state.loadedImageData != nil)
        #expect(!store.state.isLoading)
    }
    
    @Test("For gallery mode, when image is alread loaded, set property of image, triggering reload of view")
    func onAppearFromGalleryModeImageLoaded() async {
        // given
        let selectedURL = "https://example.com/already.jpg"
        let preselectedImageData = UIImage(systemName: "star")!.pngData()
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogCardFeature.State(
            dog: dog,
            mode: .fromGallery(selectedURL),
            isLoading: true,
            loadedImageData: preselectedImageData,
            selectedImageUrl: selectedURL
        )) {
            DogCardFeature()
        } withDependencies: {
            $0.dogCardNetwork = network
            $0.dogCardURLSession = urlSession
        }
        
        // when
        await store.send(.onAppear) {
            $0.isLoading = false
        }
        await store.finish()
        
        // then
        #expect(network.getBreedRandomImageCalled == 0)
        #expect(store.state.loadedImageData == preselectedImageData)
        #expect(!store.state.isLoading)
    }
    
    @Test("For gallery mode, when image is not loaded yet, load image, set property of image, triggering reload of view")
    func onAppearFromGalleryModeImageNotLoaded() async {
        // given
        // stub image data for URLSession
        let image = UIImage(systemName: "star")!
        let imageData = image.pngData()!
        urlSession.data = imageData
        let urlString = "https://example.com/already.jpg"
        
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogCardFeature.State(
            dog: dog,
            mode: .fromGallery(urlString),
            isLoading: false,
            loadedImageData: nil,
            selectedImageUrl: urlString
        )) {
            DogCardFeature()
        } withDependencies: {
            $0.dogCardNetwork = network
            $0.dogCardURLSession = urlSession
        }
        
        // when
        await store.send(.onAppear)
        await store.receive(\.loadImage) {
            $0.isLoading = true
        }
        await store.receive(\.imageDataLoaded) {
            $0.loadedImageData = imageData
            $0.isLoading = false
        }
        await store.finish()
        
        // then
        #expect(network.getBreedRandomImageCalled == 0)
        #expect(urlSession.fetchDataCalled == 1)
        #expect(store.state.loadedImageData == imageData)
    }
    
    @Test
    func loadRandomImageWithError() async {
        // given
        network.shouldThrowError = true
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogCardFeature.State(dog: dog, mode: .main, isLoading: false)) {
            DogCardFeature()
        } withDependencies: {
            $0.dogCardNetwork = network
            $0.dogCardURLSession = urlSession
        }
        
        // when
        await store.send(.loadRandomImage) {
            $0.isLoading = true
        }
        // then
        await store.receive(\.handleRandomImage.failure) {
            $0.isLoading = false
        }
        await store.finish()
        #expect(network.getBreedRandomImageCalled == 1)
    }
    
    @Test
    func loadImageUrlSessionError() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogCardFeature.State(dog: dog, mode: .main, isLoading: false, loadedImageData: Data())) {
            DogCardFeature()
        } withDependencies: {
            $0.dogCardNetwork = network
            $0.dogCardURLSession = urlSession
        }
        urlSession.shouldThrowError = true
        // when
        await store.send(.loadImage(url: "some url")) {
            $0.isLoading = true
        }
        await store.receive(\.imageDataLoaded) {
            $0.loadedImageData = nil
            $0.isLoading = false
        }
        await store.finish()
        #expect(store.state.loadedImageData == nil)
    }
    
    @Test
    func saveTappedPermissionAllowed() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let imageData = UIImage(systemName: "star")!.pngData()
        let store = TestStore(initialState: DogCardFeature.State(
            dog: dog,
            mode: .main,
            isLoading: false,
            loadedImageData: imageData
        )) {
            DogCardFeature()
        } withDependencies: {
            $0.dogCardNetwork = network
            $0.photoLibraryService = photoLibraryService
        }
        photoLibraryService.statusToReturn = .authorized
        // when
        await store.send(.saveTapped)
        // then
        await store.receive(\.savedToPhotos) {
            $0.showSaveConfirmAlert = true
        }
        await store.finish()
        #expect(photoLibraryService.requestAuthorizationCalled == 1)
        #expect(photoLibraryService.saveImageInPhotoAlbumCalled == 1)
        #expect(photoLibraryService.savedImageData == imageData)
        #expect(!store.state.showDeniedGalleryAlert)
        #expect(store.state.showSaveConfirmAlert)
    }
    
    @Test
    func saveTappedPermissionDenied() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let imageData = UIImage(systemName: "star")!.pngData()
        let store = TestStore(initialState: DogCardFeature.State(
            dog: dog,
            mode: .main,
            isLoading: false,
            loadedImageData: imageData
        )) {
            DogCardFeature()
        } withDependencies: {
            $0.dogCardNetwork = network
            $0.photoLibraryService = photoLibraryService
        }
        photoLibraryService.statusToReturn = .denied
        // when
        await store.send(.saveTapped)
        // then
        await store.receive(\.saveDenied) {
            $0.showDeniedGalleryAlert = true
        }
        await store.finish()
        #expect(photoLibraryService.requestAuthorizationCalled == 1)
        #expect(photoLibraryService.saveImageInPhotoAlbumCalled == 0)
        #expect(photoLibraryService.savedImageData == nil)
        #expect(store.state.showDeniedGalleryAlert)
        #expect(!store.state.showSaveConfirmAlert)
    }
}
