//
//  DogsListFeature+Dependencies.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.10.2025.
//

import ComposableArchitecture

// MARK: - DogsListNetwork Dependency
private enum DogsListNetworkKey: DependencyKey {
    static let liveValue: DogsListNetwork = DogsNetworkService()
}

extension DependencyValues {
    var dogsListNetwork: DogsListNetwork {
        get { self[DogsListNetworkKey.self] }
        set { self[DogsListNetworkKey.self] = newValue }
    }
}

// MARK: - DogsListFavoriteStorage Dependency
private enum DogsListFavoriteStorageKey: DependencyKey {
    static let liveValue: DogsListFavoriteStorage = FavoriteDogBreedsStorage()
}

extension DependencyValues {
    var dogsListFavoriteStorage: DogsListFavoriteStorage {
        get { self[DogsListFavoriteStorageKey.self] }
        set { self[DogsListFavoriteStorageKey.self] = newValue }
    }
}
