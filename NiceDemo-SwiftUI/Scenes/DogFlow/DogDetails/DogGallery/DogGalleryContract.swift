//
//  DogGalleryContract.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 11.08.2025.
//

import Foundation

protocol DogGalleryNetwork {
    func getBreedRandomImages(_ breed: String, amount: Int) async throws -> GetBreedRandomImagesServerResponse
}
extension DogsNetworkService: DogGalleryNetwork {}
