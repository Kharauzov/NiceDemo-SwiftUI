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
    
    private var task: Task<Void, Never>?
    private var continuation: AsyncStream<[String]>.Continuation?
    var favBreedsStream: AsyncStream<[String]>?
    
    deinit {
        task?.cancel()
        finishStream()
    }
    
    init(favoriteBreedsStorage: FavoriteBreedsStorageInterface = FavoriteDogBreedsStorage(), connectivityService: WatchFavoriteBreedsConnectivity = WCService.shared) {
        self.favoriteBreedsStorage = favoriteBreedsStorage
        self.connectivityService = connectivityService
        self.favBreedsStream = AsyncStream { continuation in
            self.continuation = continuation
        }
        task = Task { [weak self] in
            guard let self else { return }
            if let favBreedsStream = connectivityService.favBreedsStream {
                for await payload in favBreedsStream {
                    let updated = self.favoriteBreedsStorage.refreshFavBreedsPayloadIfNewer(payload)
                    if updated {
                        continuation?.yield(payload.breeds)
                    }
                }
            }
        }
    }
    
    func finishStream() {
        continuation?.finish()
    }
    
    func sendFavoriteBreedsViaConnectivity() {
        connectivityService.sendFavoriteBreeds(favoriteBreedsStorage.getFavBreedsPayload())
    }
}
