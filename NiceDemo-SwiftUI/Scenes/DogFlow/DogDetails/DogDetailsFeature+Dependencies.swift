//
//  DogDetailsFeature+Dependencies.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import Foundation
import ComposableArchitecture

// MARK: - DogsListNetwork Dependency
private enum DogDetailsFavoriteStorageKey: DependencyKey {
    static let liveValue: DogDetailsFavoriteStorage = FavoriteDogBreedsStorage()
}

extension DependencyValues {
    var favoriteStorage: DogDetailsFavoriteStorage {
        get { self[DogDetailsFavoriteStorageKey.self] }
        set { self[DogDetailsFavoriteStorageKey.self] = newValue }
    }
}
