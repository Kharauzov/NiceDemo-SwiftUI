//
//  MockWatchFavoriteBreedsConnectivity.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 06.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockWatchFavoriteBreedsConnectivity: WatchFavoriteBreedsConnectivity {
    var favBreedsContinuation: AsyncStream<FavoriteBreedsPayload>.Continuation?
    var favBreedsStream: AsyncStream<FavoriteBreedsPayload>?
    var favBreedsPayload: FavoriteBreedsPayload? {
        didSet {
            if oldValue != favBreedsPayload, let favBreedsPayload {
                favBreedsContinuation?.yield(favBreedsPayload)
            }
        }
    }
    var favBreedsPayloadChanged: ((FavoriteBreedsPayload) -> Void)?
    var sentFavoriteBreedsPayload: FavoriteBreedsPayload?
    var sendFavoriteBreedsCalled = 0
    
    init() {
        self.favBreedsStream = AsyncStream { continuation in
            self.favBreedsContinuation = continuation
        }
    }
    
    deinit {
        favBreedsContinuation?.finish()
    }
    
    func sendFavoriteBreeds(_ payload: FavoriteBreedsPayload) {
        sendFavoriteBreedsCalled += 1
        sentFavoriteBreedsPayload = payload
    }
}
