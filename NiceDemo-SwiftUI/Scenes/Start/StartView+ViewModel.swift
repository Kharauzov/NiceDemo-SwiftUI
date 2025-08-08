//
//  StartView+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI

extension StartView {
    @Observable
    class ViewModel {
        var isUserAuthenticated: Bool {
            userCredentialsStorage.isUserAuthenticated
        }
        private let userCredentialsStorage: UserCredentialsFetching
        
        init(userCredentialsStorage: UserCredentialsFetching) {
            self.userCredentialsStorage = userCredentialsStorage
        }
        
        func fetchUserAuthState() async -> Bool {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            return userCredentialsStorage.isUserAuthenticated
        }
    }
}
