//
//  DogsListFeatureTests.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 06.10.2025.
//

import Foundation
import Testing
import ComposableArchitecture
@testable import NiceDemo_SwiftUI

@MainActor
struct DogsListFeatureTests {
    // Shared dependencies
    let networkService = MockDogsListNetwork()
    let favoriteStorage = MockDogsListFavoriteStorage()
    let syncFavoriteBreedsStorage = MockFavoriteBreedsStorageInterface()
    let watchFavoriteBreedsConnectivity = MockWatchFavoriteBreedsConnectivity()
    var favoriteBreedsSyncService: MockFavoriteBreedsSyncService!
    
    init() {
        favoriteBreedsSyncService = .init(favoriteBreedsStorage: syncFavoriteBreedsStorage, connectivityService: watchFavoriteBreedsConnectivity)
    }
    
    @Test("Listening to favorite breeds storage change through WatchConnectivity. Further handling of change through `reloadData` action.")
    func onAppear() async {
        let dogs = [
            Dog(breed: "Test1", subbreeds: nil, isFavorite: false),
            Dog(breed: "Test2", subbreeds: nil, isFavorite: false),
            Dog(breed: "Test3", subbreeds: nil, isFavorite: false)
        ]
        // given
        let store = TestStore(initialState: DogsListFeature.State(dogs: dogs, isLoading: true)) {
            DogsListFeature()
        } withDependencies: {
            $0.dogsListNetwork = networkService
            $0.dogsListFavoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        // setting these breeds as favorite in storage
        favoriteStorage.mockFavoriteDogsBreeds = ["Test1", "Test2"]
        let timeinterval = TimeInterval()
        // just empty payload for test purpose
        let payload = FavoriteBreedsPayload(breeds: [], updatedAt: timeinterval)
        // force refresh condition for test purpose
        syncFavoriteBreedsStorage.shouldRefreshFavBreedsPayloadIfNewer = true
        // when
        await store.send(.onAppear)
        // simulating watchConnectivity event
        watchFavoriteBreedsConnectivity.favBreedsPayload = payload
        // then
        await store.receive(\.reloadData) {
            $0.isLoading = false
            $0.dogs = [
                Dog(breed: "Test1", subbreeds: nil, isFavorite: true),
                Dog(breed: "Test2", subbreeds: nil, isFavorite: true),
                Dog(breed: "Test3", subbreeds: nil, isFavorite: false)
            ]
        }
        // we need to finish stream to avoid error of running effect after test completion.
        favoriteBreedsSyncService.finishStream()
        await store.finish()
        #expect(syncFavoriteBreedsStorage.refreshFavBreedsPayloadIfNewerCalled == 1)
    }
    
    @Test
    func loadDogsListSuccessfulResponse() async {
        // given
        let store = TestStore(initialState: DogsListFeature.State()) {
            DogsListFeature()
        } withDependencies: {
            $0.dogsListNetwork = networkService
            $0.dogsListFavoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        networkService.getDogsResponse = GetAllDogsServerResponse(data: [
            "Test1": [],
            "Test2": []
        ])
        networkService.shouldThrowError = false
        // when
        await store.send(.loadDogsList) {
            $0.shouldLoadData = false
            $0.isLoading = true
        }
        // then
        await store.receive(\.handleFetchedDogsList) {
            $0.isLoading = false
            $0.dogs = [
                Dog(breed: "Test1", subbreeds: [], isFavorite: false),
                Dog(breed: "Test2", subbreeds: [], isFavorite: false)
            ]
        }
        await store.finish()
        #expect(networkService.getDogsCalled == 1)
    }
    
    @Test
    func loadDogsListFailedResponse() async {
        // given
        let store = TestStore(initialState: DogsListFeature.State()) {
            DogsListFeature()
        } withDependencies: {
            $0.dogsListNetwork = networkService
            $0.dogsListFavoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        networkService.shouldThrowError = true
        #expect(store.state.dogs.isEmpty)
        // when
        await store.send(.loadDogsList) {
            $0.shouldLoadData = false
            $0.isLoading = true
        }
        // then
        await store.receive(\.handleFetchedDogsList) {
            $0.isLoading = false
        }
        await store.finish()
        #expect(store.state.dogs.isEmpty)
    }
    
    @Test
    func removeFromFavorite() async {
        // given
        let store = TestStore(initialState: DogsListFeature.State()) {
            DogsListFeature()
        } withDependencies: {
            $0.dogsListNetwork = networkService
            $0.dogsListFavoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        let mockDog = Dog(breed: "test", subbreeds: [], isFavorite: false)
        // when
        await store.send(.removeFromFavorite(mockDog))
        // then
        await store.receive(\.reloadData) {
            $0.isLoading = false
        }
        #expect(favoriteStorage.removeFromFavoriteDogValue == mockDog)
        #expect(favoriteStorage.removeFromFavoriteCalled == 1)
        #expect(favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivityCalled == 1)
    }
    
    @Test("Should return only favorite dogs inside filteredDogs when selectedFilter is .favorite")
    func selectFilterFavorite() async {
        // given
        let dogs = [
            Dog(breed: "Test1", subbreeds: nil, isFavorite: true),
            Dog(breed: "Test2", subbreeds: nil, isFavorite: true),
            Dog(breed: "Test3", subbreeds: nil, isFavorite: false)
        ]
        let store = TestStore(initialState: DogsListFeature.State(dogs: dogs)) {
            DogsListFeature()
        } withDependencies: {
            $0.dogsListNetwork = networkService
            $0.dogsListFavoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        #expect(store.state.searchText.isEmpty)
        #expect(store.state.selectedFilter == DogsListFilter.all)
        #expect(store.state.filteredDogs == dogs)
        let selectFilter = DogsListFilter.favorite
        // when
        await store.send(.selectFilter(selectFilter)) {
            $0.selectedFilter = selectFilter
        }
        // then
        #expect(store.state.filteredDogs == [
            Dog(breed: "Test1", subbreeds: nil, isFavorite: true),
            Dog(breed: "Test2", subbreeds: nil, isFavorite: true)
        ])
    }
    
    @Test("Should return all dogs inside filteredDogs when selectedFilter is .all")
    func selectFilterAll() async {
        // given
        let givenSelectFilter = DogsListFilter.favorite
        let dogs = [
            Dog(breed: "Test1", subbreeds: nil, isFavorite: true),
            Dog(breed: "Test2", subbreeds: nil, isFavorite: true),
            Dog(breed: "Test3", subbreeds: nil, isFavorite: false)
        ]
        let store = TestStore(initialState: DogsListFeature.State(dogs: dogs, selectedFilter: givenSelectFilter)) {
            DogsListFeature()
        } withDependencies: {
            $0.dogsListNetwork = networkService
            $0.dogsListFavoriteStorage = favoriteStorage
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        #expect(store.state.searchText.isEmpty)
        #expect(store.state.selectedFilter == givenSelectFilter)
        #expect(store.state.filteredDogs == [
            Dog(breed: "Test1", subbreeds: nil, isFavorite: true),
            Dog(breed: "Test2", subbreeds: nil, isFavorite: true)
        ])
        let newSelectFilter: DogsListFilter = .all
        // when
        await store.send(.selectFilter(newSelectFilter)) {
            $0.selectedFilter = newSelectFilter
        }
        // then
        #expect(store.state.filteredDogs == dogs)
    }
}
