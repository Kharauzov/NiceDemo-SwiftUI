//
//  DogDetailsView+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import SwiftUI

extension DogDetailsView {
    @Observable
    class ViewModel {
        private(set) var dog: Dog
        private(set) var favoriteButtonImageName = ""
        private(set) var randomDogImageUrl = ""
        private let networkService: DogDetailsNetwork
        private let favoriteStorage: DogDetailsFavoriteStorage
        var loading = true
        
        init(dog: Dog, networkService: DogDetailsNetwork, favoriteStorage: DogDetailsFavoriteStorage) {
            self.dog = dog
            self.networkService = networkService
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
        
        @MainActor
        func loadRandomImage() {
            loading = true
            Task {
                do {
                    let response = try await networkService.getBreedRandomImage(dog.breed)
                    randomDogImageUrl = response.data ?? ""
                } catch _ {
                    // handle error here
                }
            }
        }
        
        private func setFavoriteButtonImageName() {
            favoriteButtonImageName = dog.isFavorite ? "pawPrintSelected" : "pawPrintNotSelected"
        }
    }
}
