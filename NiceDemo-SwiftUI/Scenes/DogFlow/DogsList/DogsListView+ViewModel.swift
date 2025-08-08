//
//  DogsListView+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import SwiftUI

extension DogsListView {
    @Observable
    class ViewModel {
        private var dogs = [Dog]()
        private let networkService: DogsListNetwork
        private let favoriteStorage: DogsListFavoriteStorage
        var networkError: Error?
        var showErrorAlert: Bool = false
        var loading = true
        var shouldLoadData = true
        
        init(networkService: DogsListNetwork, favoriteStorage: DogsListFavoriteStorage) {
            self.networkService = networkService
            self.favoriteStorage = favoriteStorage
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
    }
}
