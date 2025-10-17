//
//  SignInFeature+Dependencies.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 18.08.2025.
//

import ComposableArchitecture

private struct UserCredentialsUpdatingKey: DependencyKey {
    static let liveValue: UserCredentialsUpdating = UserCredentialsStorage()
}

private struct WatchConnectivityServiceKey: DependencyKey {
    static let liveValue: WatchSignInConnectivityInterface = WCService.shared
}

extension DependencyValues {
    var userCredentialsUpdateStorage: UserCredentialsUpdating {
        get { self[UserCredentialsUpdatingKey.self] }
        set { self[UserCredentialsUpdatingKey.self] = newValue }
    }
    
    var watchConnectivityService: WatchSignInConnectivityInterface {
        get { self[WatchConnectivityServiceKey.self] }
        set { self[WatchConnectivityServiceKey.self] = newValue }
    }
}
