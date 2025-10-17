//
//  StartFeature+Dependencies.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 02.10.2025.
//

import ComposableArchitecture

private struct ConnectivityServiceKey: DependencyKey {
    static let liveValue: PhoneSignInConnectivityInterface = WCService.shared
}

private struct UserCredentialsFetchingKey: DependencyKey {
    static let liveValue: UserCredentialsFetching = UserCredentialsStorage()
}

private struct FavoriteBreedsSyncServiceKey: DependencyKey {
    static let liveValue: FavoriteBreedsSyncService = FavoriteBreedsSyncService()
}

extension DependencyValues {
    var connectivityService: PhoneSignInConnectivityInterface {
        get { self[ConnectivityServiceKey.self] }
        set { self[ConnectivityServiceKey.self] = newValue }
    }
    var userCredentialsFetchStorage: UserCredentialsFetching {
        get { self[UserCredentialsFetchingKey.self] }
        set { self[UserCredentialsFetchingKey.self] = newValue }
    }
    var favoriteBreedsSyncService: FavoriteBreedsSyncService {
        get { self[FavoriteBreedsSyncServiceKey.self] }
        set { self[FavoriteBreedsSyncServiceKey.self] = newValue }
    }
}
