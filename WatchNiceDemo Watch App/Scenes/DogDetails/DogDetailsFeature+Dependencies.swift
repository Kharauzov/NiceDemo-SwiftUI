//
//  DogDetailsFeature+Dependencies.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import ComposableArchitecture

private struct DogDetailsFavoriteStorageKey: DependencyKey {
    static let liveValue: DogDetailsFavoriteStorage = FavoriteDogBreedsStorage()
}

private struct DogDetailsNetworkKey: DependencyKey {
    static let liveValue: DogDetailsNetwork = DogsNetworkService()
}

extension DependencyValues {
    var favoriteStorage: DogDetailsFavoriteStorage {
        get { self[DogDetailsFavoriteStorageKey.self] }
        set { self[DogDetailsFavoriteStorageKey.self] = newValue }
    }
    
    var dogDetailsNetwork: DogDetailsNetwork {
        get { self[DogDetailsNetworkKey.self] }
        set { self[DogDetailsNetworkKey.self] = newValue }
    }
}
