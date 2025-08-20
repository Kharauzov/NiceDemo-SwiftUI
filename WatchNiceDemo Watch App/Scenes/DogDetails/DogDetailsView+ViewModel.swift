//
//  DogDetailsView+ViewModel.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import Foundation

extension DogDetailsView {
    @Observable
    class ViewModel {
        private(set) var dog: Dog
        private let favoriteStorage: DogDetailsFavoriteStorage
        private let networkService: DogDetailsNetwork
        private(set) var loading = true
        private(set) var favoriteButtonImageName = ""
        private(set) var randomImageUrl: String?
        
        init(dog: Dog, favoriteStorage: DogDetailsFavoriteStorage, networkService: DogDetailsNetwork) {
            self.dog = dog
            self.favoriteStorage = favoriteStorage
            self.networkService = networkService
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
                    loading = false
                    randomImageUrl = response.data ?? ""
                } catch _ {
                    // handle error here
                }
            }
        }
        
        private func setFavoriteButtonImageName() {
            favoriteButtonImageName = dog.isFavorite ? "heart.fill" : "heart"
        }
    }
}
