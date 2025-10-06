//
//  MockFavoriteBreedsStorageInterface.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 06.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockFavoriteBreedsStorageInterface: FavoriteBreedsStorageInterface {
    var shouldRefreshFavBreedsPayloadIfNewer = false
    var refreshFavBreedsPayloadIfNewerCalled = 0
    var favBreedsPayload = FavoriteBreedsPayload(breeds: [], updatedAt: TimeInterval())
    
    func refreshFavBreedsPayloadIfNewer(_ payload: FavoriteBreedsPayload) -> Bool {
        refreshFavBreedsPayloadIfNewerCalled += 1
        return shouldRefreshFavBreedsPayloadIfNewer
    }
    
    func getFavBreedsPayload() -> FavoriteBreedsPayload {
        favBreedsPayload
    }
}
