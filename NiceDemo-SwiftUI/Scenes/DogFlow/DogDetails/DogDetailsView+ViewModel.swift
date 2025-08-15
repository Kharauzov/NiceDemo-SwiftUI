//
//  DogDetailsView+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import SwiftUI
import UIKit
import Photos

extension DogDetailsView {
    @Observable
    class ViewModel {
        private(set) var dog: Dog
        private(set) var favoriteButtonImageName = ""
        private let favoriteStorage: DogDetailsFavoriteStorage
        
        init(dog: Dog, favoriteStorage: DogDetailsFavoriteStorage) {
            self.dog = dog
            self.favoriteStorage = favoriteStorage
            setFavoriteButtonImageName()
        }
        
        func handleFavoriteButtonTap() {
            if dog.isFavorite {
                favoriteStorage.removeFromFavorite(dog)
            } else {
                favoriteStorage.addToFavorite(dog)
            }
            dog.isFavorite.toggle()
            setFavoriteButtonImageName()
        }
        
        private func setFavoriteButtonImageName() {
            favoriteButtonImageName = dog.isFavorite ? "pawPrintSelected" : "pawPrintNotSelected"
        }
    }
}
