//
//  MockFavoriteBreedsSyncService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 03.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockFavoriteBreedsSyncService: FavoriteBreedsSyncService {
    var sendFavoriteBreedsViaConnectivityCalled = 0
    
    override func sendFavoriteBreedsViaConnectivity() {
        sendFavoriteBreedsViaConnectivityCalled += 1
    }
}
