//
//  DogCardContract.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import Foundation
import Photos

protocol DogCardNetwork {
    func getBreedRandomImage(_ breed: String) async throws -> GetRandomDogImageServerResponse
}
extension DogsNetworkService: DogCardNetwork {}

protocol DogCardURLSession {
    func data(from url: URL) async throws -> Data
}

protocol DogCardPhotoLibraryInterface {
    func saveImageInPhotoAlbum(_ imageData: Data)
    func requestAuthorization(completion: @escaping (PHAuthorizationStatus) -> Void)
}
extension PhotoLibraryService: DogCardPhotoLibraryInterface {}
