//
//  DogsNetworkService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

class DogsNetworkService: NetworkService {
    func getDogs() async throws -> GetAllDogsServerResponse {
        return try await request(DogsEndpoint.getBreeds)
    }
    
    func getBreedRandomImage(_ breed: String) async throws -> GetRandomDogImageServerResponse {
        return try await request(DogsEndpoint.getRandomPhoto(breed))
    }
}
