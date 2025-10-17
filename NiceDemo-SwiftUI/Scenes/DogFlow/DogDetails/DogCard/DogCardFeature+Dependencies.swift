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

struct DogCardURLSessionKey: DependencyKey {
    static var liveValue: DogCardURLSession = SimpleDataLoader()
}

extension DependencyValues {
    var dogCardURLSession: DogCardURLSession {
        get { self[DogCardURLSessionKey.self] }
        set { self[DogCardURLSessionKey.self] = newValue }
    }
}

struct DogCardPhotoLibraryInterfaceKey: DependencyKey {
    static var liveValue: DogCardPhotoLibraryInterface = PhotoLibraryService()
}

extension DependencyValues {
    var photoLibraryService: DogCardPhotoLibraryInterface {
        get { self[DogCardPhotoLibraryInterfaceKey.self] }
        set { self[DogCardPhotoLibraryInterfaceKey.self] = newValue }
    }
}
