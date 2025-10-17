//
//  MockDogsListFavoriteStorage.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 06.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockDogsListFavoriteStorage: DogsListFavoriteStorage {
    var removeFromFavoriteCalled = 0
    var removeFromFavoriteDogValue: Dog?
    var mockFavoriteDogsBreeds: [String] = []
    
    var favoriteDogBreeds: [String] {
        mockFavoriteDogsBreeds
    }
    
    func removeFromFavorite(_ dog: Dog) {
        removeFromFavoriteCalled += 1
        removeFromFavoriteDogValue = dog
    }
}
