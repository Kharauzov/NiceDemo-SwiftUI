//
//  SignInView+ViewModel.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 18.08.2025.
//

import SwiftUI
import Combine

extension SignInView {
    @Observable
    class ViewModel {
        private var cancellables = Set<AnyCancellable>()
        let userCredentialsStorage: UserCredentialsUpdating
        var connectivityService: WatchSignInConnectivityInterface
        
        init(connectivityService: WatchSignInConnectivityInterface, userCredentialsStorage: UserCredentialsUpdating) {
            self.connectivityService = connectivityService
            self.userCredentialsStorage = userCredentialsStorage
        }
        
        func saveAuthState(_ isUserAuthenticated: Bool) {
            userCredentialsStorage.isUserAuthenticated = isUserAuthenticated
        }
    }
}
