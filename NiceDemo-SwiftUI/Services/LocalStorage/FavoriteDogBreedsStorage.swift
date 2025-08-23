//
//  FavoriteDogBreedsStorage.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

class FavoriteDogBreedsStorage {
    private let storage: FavoriteDogBreedsStoring
    
    init(storage: FavoriteDogBreedsStoring = UserDefaultsLayer()) {
        self.storage = storage
    }
    
    // MARK: Public properties
    
    var favoriteDogBreeds: [String] {
        storage.favoriteDogBreeds
    }
    
    var favoriteBreedsUpdatedAt: TimeInterval {
        storage.favoriteBreedsUpdatedAt
    }
    
    func removeFromFavorite(_ dog: Dog) {
        storage.favoriteDogBreeds.removeAll { $0 == dog.breed }
        storage.favoriteBreedsUpdatedAt = Date().timeIntervalSince1970
    }
    
    func addToFavorite(_ dog: Dog) {
        if !favoriteDogBreeds.contains(dog.breed) {
            storage.favoriteDogBreeds.append(dog.breed)
            storage.favoriteBreedsUpdatedAt = Date().timeIntervalSince1970
        }
    }
    
    func refreshBreedsBased(on payload: FavoriteBreedsPayload) {
        storage.favoriteDogBreeds = payload.breeds
        storage.favoriteBreedsUpdatedAt = payload.updatedAt
    }
    
    @discardableResult
    func refreshFavBreedsPayloadIfNewer(_ payload: FavoriteBreedsPayload) -> Bool {
        guard payload.updatedAt > favoriteBreedsUpdatedAt else {
            return false
        }
        refreshBreedsBased(on: payload)
        return true
    }
    
    func getFavBreedsPayload() -> FavoriteBreedsPayload {
        FavoriteBreedsPayload(breeds: favoriteDogBreeds, updatedAt: favoriteBreedsUpdatedAt)
    }
}
