//
//  SignInFeature+Dependencies.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 03.10.2025.
//

import ComposableArchitecture

private struct UserCredentialsUpdatingKey: DependencyKey {
    static let liveValue: UserCredentialsUpdating = UserCredentialsStorage()
}

extension DependencyValues {
    var userCredentialsUpdateStorage: UserCredentialsUpdating {
        get { self[UserCredentialsUpdatingKey.self] }
        set { self[UserCredentialsUpdatingKey.self] = newValue }
    }
}
