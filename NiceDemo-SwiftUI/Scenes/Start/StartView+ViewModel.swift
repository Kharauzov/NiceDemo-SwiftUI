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
        private let connectivityService: PhoneSignInConnectivityInterface
        private let userCredentialsStorage: UserCredentialsFetching
        private let favoriteBreedsSyncService: FavoriteBreedsSyncService
        
        init(userCredentialsStorage: UserCredentialsFetching, connectivityService: PhoneSignInConnectivityInterface, favoriteBreedsSyncService: FavoriteBreedsSyncService) {
            self.userCredentialsStorage = userCredentialsStorage
            self.connectivityService = connectivityService
            self.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        
        func fetchUserAuthState() async -> Bool {
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 second
            connectivityService.sendAuth(flag: isUserAuthenticated)
            if isUserAuthenticated {
                favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivity()
            }
            return isUserAuthenticated
        }
    }
}
