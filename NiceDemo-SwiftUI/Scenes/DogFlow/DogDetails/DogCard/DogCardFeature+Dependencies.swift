//
//  DogCardFeature+Dependencies.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 09.10.2025.
//

import Foundation
import ComposableArchitecture

// MARK: - Dependencies

struct DogCardNetworkKey: DependencyKey {
    static var liveValue: DogCardNetwork = DogsNetworkService()
}

extension DependencyValues {
    var dogCardNetwork: DogCardNetwork {
        get { self[DogCardNetworkKey.self] }
        set { self[DogCardNetworkKey.self] = newValue }
    }
}
