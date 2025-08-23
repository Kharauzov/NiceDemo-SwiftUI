//
//  DogDetailsContract.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import Foundation

protocol DogDetailsFavoriteStorage: AnyObject {
    var favoriteDogBreeds: [String] { get }
    func removeFromFavorite(_ dog: Dog)
    func addToFavorite(_ dog: Dog)
}
extension FavoriteDogBreedsStorage: DogDetailsFavoriteStorage {}

// Used inside Watch app
protocol DogDetailsNetwork {
    func getBreedRandomImage(_ breed: String) async throws -> GetRandomDogImageServerResponse
}
extension DogsNetworkService: DogDetailsNetwork {}
