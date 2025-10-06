//
//  MockWatchFavoriteBreedsConnectivity.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 06.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockWatchFavoriteBreedsConnectivity: WatchFavoriteBreedsConnectivity {
    var favBreedsPayload: FavoriteBreedsPayload? {
        didSet {
            if oldValue != favBreedsPayload, let favBreedsPayload {
                favBreedsPayloadChanged?(favBreedsPayload)
            }
        }
    }
    var favBreedsPayloadChanged: ((FavoriteBreedsPayload) -> Void)?
    var sentFavoriteBreedsPayload: FavoriteBreedsPayload?
    var sendFavoriteBreedsCalled = 0
    
    func sendFavoriteBreeds(_ payload: FavoriteBreedsPayload) {
        sendFavoriteBreedsCalled += 1
        sentFavoriteBreedsPayload = payload
    }
}
