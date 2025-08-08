//
//  DogsListContract.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

protocol DogsListNetwork {
    func getDogs() async throws -> GetAllDogsServerResponse
}
extension DogsNetworkService: DogsListNetwork {}


protocol DogsListFavoriteStorage: AnyObject {
    var favoriteDogBreeds: [String] { get }
    func removeFromFavorite(_ dog: Dog)
}
extension FavoriteDogBreedsStorage: DogsListFavoriteStorage {}
