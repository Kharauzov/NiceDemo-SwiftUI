//
//  FavoriteBreedsSyncService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 20.08.2025.
//

import Foundation

class FavoriteBreedsSyncService {
    private let favoriteBreedsStorage: FavoriteBreedsStorageInterface
    private let connectivityService: WatchFavoriteBreedsConnectivity
    
    private var continuation: AsyncStream<[String]>.Continuation?
    var favoriteBreedsUpdateFromPeer: AsyncStream<[String]> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }
    
    deinit {
        continuation?.finish()
    }
    
    init(favoriteBreedsStorage: FavoriteBreedsStorageInterface = FavoriteDogBreedsStorage(), connectivityService: WatchFavoriteBreedsConnectivity = WCService.shared) {
        self.favoriteBreedsStorage = favoriteBreedsStorage
        self.connectivityService = connectivityService
        
        connectivityService.favBreedsPayloadChanged = { [weak self] payload in
            guard let self else { return }
            let flag = self.favoriteBreedsStorage.refreshFavBreedsPayloadIfNewer(payload)
            if flag {
                continuation?.yield(payload.breeds)
            }
        }
    }
    
    func sendFavoriteBreedsViaConnectivity() {
        connectivityService.sendFavoriteBreeds(favoriteBreedsStorage.getFavBreedsPayload())
    }
}
