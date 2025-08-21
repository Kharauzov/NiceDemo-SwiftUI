//
//  FavoriteBreedsPayload.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 20.08.2025.
//

import Foundation

struct FavoriteBreedsPayload: Codable, Equatable {
    var breeds: [String]
    var updatedAt: TimeInterval
}
