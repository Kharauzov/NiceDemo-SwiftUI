//
//  DogGalleryFeature+Dependencies.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 08.10.2025.
//

import ComposableArchitecture

// MARK: - DogGalleryNetwork Dependency
private enum DogGalleryNetworkKey: DependencyKey {
    static let liveValue: DogGalleryNetwork = DogsNetworkService()
}

extension DependencyValues {
    var dogGalleryNetwork: DogGalleryNetwork {
        get { self[DogGalleryNetworkKey.self] }
        set { self[DogGalleryNetworkKey.self] = newValue }
    }
}

