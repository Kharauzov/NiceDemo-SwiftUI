//
//  MockDogDetailsFavoriteStorage.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 17.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockDogDetailsFavoriteStorage: DogDetailsFavoriteStorage {
    var removeFromFavoriteCalled = 0
    var removeFromFavoriteDogValue: Dog?
    var addToFavoriteCalled = 0
    var addToFavoriteDogValue: Dog?
    var mockFavoriteDogsBreeds: [String] = []
    
    var favoriteDogBreeds: [String] {
        mockFavoriteDogsBreeds
    }
    
    func removeFromFavorite(_ dog: Dog) {
        removeFromFavoriteCalled += 1
        removeFromFavoriteDogValue = dog
    }
    
    func addToFavorite(_ dog: Dog) {
        addToFavoriteCalled += 1
        addToFavoriteDogValue = dog
    }
}


