//
//  DogCardContract.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import Foundation

protocol DogCardNetwork {
    func getBreedRandomImage(_ breed: String) async throws -> GetRandomDogImageServerResponse
}
extension DogsNetworkService: DogCardNetwork {}
