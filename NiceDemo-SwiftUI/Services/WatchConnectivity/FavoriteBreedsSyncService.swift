//
//  FavoriteBreedsSyncService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 20.08.2025.
//

import Foundation

@objc protocol FavoriteBreedsSyncDelegate: AnyObject {
    @objc optional func favoritesDidUpdateLocally(_ breeds: [String])
    @objc optional func favoritesDidUpdateFromPeer(_ breeds: [String])
}

class FavoriteBreedsSyncService {
    private let favoriteBreedsStorage: FavoriteBreedsStorageInterface
    private let connectivityService: WatchFavoriteBreedsConnectivity
    weak var delegate: FavoriteBreedsSyncDelegate?
    
    init(favoriteBreedsStorage: FavoriteBreedsStorageInterface = FavoriteDogBreedsStorage(), connectivityService: WatchFavoriteBreedsConnectivity = WCService.shared) {
        self.favoriteBreedsStorage = favoriteBreedsStorage
        self.connectivityService = connectivityService
        
        connectivityService.favBreedsPayloadChanged = { [weak self] payload in
            let flag = self?.favoriteBreedsStorage.refreshFavBreedsPayloadIfNewer(payload) ?? false
            if flag {
                self?.delegate?.favoritesDidUpdateFromPeer?(payload.breeds)
            }
        }
    }
    
    func sendFavoriteBreedsViaConnectivity() {
        connectivityService.sendFavoriteBreeds(favoriteBreedsStorage.getFavBreedsPayload())
    }
}
