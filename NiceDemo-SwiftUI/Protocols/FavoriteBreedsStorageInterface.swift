//
//  FavoriteBreedsStorageInterface.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 20.08.2025.
//

import Foundation

protocol FavoriteBreedsStorageInterface {
    func refreshFavBreedsPayloadIfNewer(_ payload: FavoriteBreedsPayload) -> Bool
    func getFavBreedsPayload() -> FavoriteBreedsPayload
}
extension FavoriteDogBreedsStorage: FavoriteBreedsStorageInterface {}
