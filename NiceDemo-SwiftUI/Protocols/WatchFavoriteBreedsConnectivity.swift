//
//  WatchFavoriteBreedsConnectivity.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.08.2025.
//

import Foundation

protocol WatchFavoriteBreedsConnectivity: AnyObject {
    var favBreedsStream: AsyncStream<FavoriteBreedsPayload>? { get }
    func sendFavoriteBreeds(_ payload: FavoriteBreedsPayload)
}
extension WCService: WatchFavoriteBreedsConnectivity {}
