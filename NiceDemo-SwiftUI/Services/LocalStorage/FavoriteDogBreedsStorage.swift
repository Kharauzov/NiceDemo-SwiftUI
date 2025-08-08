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
    
    func removeFromFavorite(_ dog: Dog) {
        storage.favoriteDogBreeds.removeAll { $0 == dog.breed }
    }
    
    func addToFavorite(_ dog: Dog) {
        if !favoriteDogBreeds.contains(dog.breed) {
            storage.favoriteDogBreeds.append(dog.breed)
        }
    }
}
