//
//  DogsListView+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import SwiftUI

extension DogsListView {
    @Observable
    class ViewModel: FavoriteBreedsSyncDelegate {
        private var dogs = [Dog]()
        private let networkService: DogsListNetwork
        private let favoriteStorage: DogsListFavoriteStorage
        private let favoriteBreedsSyncService: FavoriteBreedsSyncService
        var networkError: Error?
        var showErrorAlert: Bool = false
        var loading = true
        var shouldLoadData = true
        
        init(networkService: DogsListNetwork, favoriteStorage: DogsListFavoriteStorage, favoriteBreedsSyncService: FavoriteBreedsSyncService) {
            self.networkService = networkService
            self.favoriteStorage = favoriteStorage
            self.favoriteBreedsSyncService = favoriteBreedsSyncService
            self.favoriteBreedsSyncService.delegate = self
        }
        
        func getDogs(filterOption: DogsListView.FilterOption, searchText: String) -> [Dog] {
            let sortedDogs: [Dog] = filterOption == .all ? dogs : dogs.filter { $0.isFavorite }
            if searchText.isEmpty {
                return sortedDogs
            } else {
                return sortedDogs.filter {
                    $0.breed.lowercased().contains(searchText.lowercased())
                }
            }
        }
        
        @MainActor
        func loadData() {
            loading = true
            Task {
                do {
                    let response = try await networkService.getDogs()
                    handleFetchedData(response.formattedData)
                } catch let error {
                    networkError = error
                    showErrorAlert = true
                }
            }
        }
        
        func removeFromFavorite(_ dog: Dog) {
            favoriteStorage.removeFromFavorite(dog)
            handleFetchedData(dogs)
            favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivity()
        }
        
        func reloadData() {
            handleFetchedData(dogs)
        }
        
        private func handleFetchedData(_ fetchedDogs: [Dog]?) {
            var formattedDogs = [Dog]()
            if let data = fetchedDogs {
                data.forEach { dog in
                    let isFavorite = favoriteStorage.favoriteDogBreeds.contains(dog.breed)
                    formattedDogs.append(Dog(breed: dog.breed, subbreeds: dog.subbreeds, isFavorite: isFavorite))
                }
                dogs = formattedDogs
            } else {
                dogs = []
            }
            withAnimation(.spring()) {
                loading = false
            }
        }
        
        func favoritesDidUpdateFromPeer(_ breeds: [String]) {
            reloadData()
        }
    }
}
