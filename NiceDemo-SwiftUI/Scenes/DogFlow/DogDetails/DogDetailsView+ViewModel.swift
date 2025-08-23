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
        private let favoriteBreedsSyncService: FavoriteBreedsSyncService
        
        init(dog: Dog, favoriteStorage: DogDetailsFavoriteStorage, favoriteBreedsSyncService: FavoriteBreedsSyncService) {
            self.dog = dog
            self.favoriteStorage = favoriteStorage
            self.favoriteBreedsSyncService = favoriteBreedsSyncService
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
            favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivity()
        }
        
        private func setFavoriteButtonImageName() {
            favoriteButtonImageName = dog.isFavorite ? "pawPrintSelected" : "pawPrintNotSelected"
        }
    }
}
