//
//  StartView+ViewModel.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import Foundation

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
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 second
            return isUserAuthenticated
        }
    }
}
