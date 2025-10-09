//
//  DogGalleryFeatureTests.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 09.10.2025.
//

import Testing
import ComposableArchitecture
import UIKit
@testable import NiceDemo_SwiftUI

@MainActor
struct DogGalleryFeatureTests {
    // Dependencies
    let network = MockDogGalleryNetwork()
    
    @Test
    func onAppearLoadRandomImages() async {
        // given
        network.response = GetBreedRandomImagesServerResponse(data: ["u1", "u2", "u3"])
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogGalleryFeature.State(dog: dog, isLoading: false)) {
            DogGalleryFeature()
        } withDependencies: {
            $0.dogGalleryNetwork = network
        }
        #expect(store.state.shouldLoadData)
        #expect(!store.state.isLoading)
        // when
        await store.send(.onAppear) {
            $0.shouldLoadData = false
        }
        await store.receive(\.loadRandomImages) {
            $0.isLoading = true
        }
        await store.receive(\.handleFetchedImages.success) {
            $0.data = ["u1", "u2", "u3"]
            $0.isLoading = false
        }
        // then
        // onAppear again should not trigger another load
        await store.send(.onAppear)
        await store.finish()
        
        #expect(store.state.randomImagesUrls.count == 3)
        #expect(network.getBreedRandomImagesCalled == 1)
    }
    
    @Test
    func onAppearShouldNotLoadRandomImages() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogGalleryFeature.State(dog: dog, isLoading: false, shouldLoadData: false)) {
            DogGalleryFeature()
        } withDependencies: {
            $0.dogGalleryNetwork = network
        }
        #expect(!store.state.shouldLoadData)
        #expect(!store.state.isLoading)
        // when
        await store.send(.onAppear)
        await store.finish()
        #expect(network.getBreedRandomImagesCalled == 0)
    }

    @Test
    func loadRandomImagesWithError() async {
        // given
        network.shouldThrowError = true
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogGalleryFeature.State(dog: dog, isLoading: false)) {
            DogGalleryFeature()
        } withDependencies: {
            $0.dogGalleryNetwork = network
        }
        #expect(store.state.data.isEmpty)
        // when
        await store.send(.loadRandomImages) {
            $0.isLoading = true
        }
        // then
        await store.receive(\.handleFetchedImages.failure) {
            $0.isLoading = false
        }
        await store.finish()
        #expect(store.state.data.isEmpty)
    }

    @Test("imageLoaded with non-nil image stores it; nil image is ignored")
    func imageLoaded() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogGalleryFeature.State(dog: dog, isLoading: false, shouldLoadData: false)) {
            DogGalleryFeature()
        } withDependencies: {
            $0.dogGalleryNetwork = network
        }
        let url1 = "u1"
        let url2 = "u2"
        let image = UIImage(systemName: "star")!

        // when
        await store.send(.imageLoaded(urlString: url1, image: image)) {
            $0.downloadedImages[url1] = image
        }
        await store.send(.imageLoaded(urlString: url2, image: nil))
        // then
        await store.finish()
        #expect(store.state.downloadedImages[url2] == nil)
    }

    @Test
    func selectImageAndCloseDetail() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogGalleryFeature.State(dog: dog, isLoading: false, shouldLoadData: false)) {
            DogGalleryFeature()
        } withDependencies: {
            $0.dogGalleryNetwork = network
        }

        // when
        await store.send(.selectImage(urlString: "u1")) {
            $0.selectedImageUrl = "u1"
            $0.showDetail = true
        }
        // then
        await store.send(.closeDetail) {
            $0.showDetail = false
            $0.selectedImageUrl = nil
        }
        await store.finish()
    }
}
