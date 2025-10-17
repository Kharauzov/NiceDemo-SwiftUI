//
//  DogDetailsFeatureTests.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import Testing
import ComposableArchitecture
@testable import NiceDemo_SwiftUI

@MainActor
struct DogDetailsFeatureTests {
    // Shared dependencies
    let favoriteStorage = MockDogDetailsFavoriteStorage()
    let favoriteBreedsSyncService = MockFavoriteBreedsSyncService()
    
    @Test
    func onAppear() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogDetailsFeature.State(dog: dog)) {
            DogDetailsFeature()
        } withDependencies: {
            $0.favoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        
        // when
        await store.send(.onAppear) {
            $0.favoriteButtonImageName = ImageName.favoriteOff.rawValue
        }
        
        // then
        #expect(store.state.favoriteButtonImageName == ImageName.favoriteOff.rawValue)
    }
    
    @Test
    func onAppearWithFavoriteDog() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: true)
        let store = TestStore(initialState: DogDetailsFeature.State(dog: dog)) {
            DogDetailsFeature()
        } withDependencies: {
            $0.favoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        
        // when
        await store.send(.onAppear) {
            $0.favoriteButtonImageName = ImageName.favoriteOn.rawValue
        }
        
        // then
        #expect(store.state.favoriteButtonImageName == ImageName.favoriteOn.rawValue)
    }
    
    @Test
    func setTabToGallery() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogDetailsFeature.State(dog: dog)) {
            DogDetailsFeature()
        } withDependencies: {
            $0.favoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        
        // when
        await store.send(.setTab(.gallery)) {
            $0.selectedTab = .gallery
        }
        
        // then
        #expect(store.state.selectedTab == .gallery)
    }
    
    @Test
    func setTabToSingle() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogDetailsFeature.State(dog: dog, selectedTab: .gallery)) {
            DogDetailsFeature()
        } withDependencies: {
            $0.favoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        
        // when
        await store.send(.setTab(.single)) {
            $0.selectedTab = .single
        }
        
        // then
        #expect(store.state.selectedTab == .single)
    }
    
    @Test
    func favoriteTappedAddToFavorites() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: false)
        let store = TestStore(initialState: DogDetailsFeature.State(dog: dog)) {
            DogDetailsFeature()
        } withDependencies: {
            $0.favoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        
        // when
        await store.send(.favoriteTapped) {
            $0.dog.isFavorite = true
            $0.dogCard.dog.isFavorite = true
            $0.dogGallery.dog.isFavorite = true
            $0.favoriteButtonImageName = ImageName.favoriteOn.rawValue
        }
        
        // then
        #expect(favoriteStorage.addToFavoriteDogValue == dog)
        #expect(favoriteStorage.addToFavoriteCalled == 1)
        #expect(favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivityCalled == 1)
        #expect(store.state.dog.isFavorite == true)
        #expect(store.state.favoriteButtonImageName == ImageName.favoriteOn.rawValue)
    }
    
    @Test
    func favoriteTappedRemoveFromFavorites() async {
        // given
        let dog = Dog(breed: "akita", subbreeds: nil, isFavorite: true)
        let store = TestStore(initialState: DogDetailsFeature.State(dog: dog)) {
            DogDetailsFeature()
        } withDependencies: {
            $0.favoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        
        // when
        await store.send(.favoriteTapped) {
            $0.dog.isFavorite = false
            $0.dogCard.dog.isFavorite = false
            $0.dogGallery.dog.isFavorite = false
            $0.favoriteButtonImageName = ImageName.favoriteOff.rawValue
        }
        
        // then
        #expect(favoriteStorage.removeFromFavoriteDogValue == dog)
        #expect(favoriteStorage.removeFromFavoriteCalled == 1)
        #expect(favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivityCalled == 1)
        #expect(store.state.dog.isFavorite == false)
        #expect(store.state.favoriteButtonImageName == ImageName.favoriteOff.rawValue)
    }
}
