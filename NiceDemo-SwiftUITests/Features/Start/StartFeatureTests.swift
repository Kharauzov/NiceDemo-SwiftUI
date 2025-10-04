//
//  StartFeatureTests.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 02.10.2025.
//

import Testing
import ComposableArchitecture
@testable import NiceDemo_SwiftUI

@MainActor
struct StartFeatureTests {
    // Shared dependencies
    let userCredentialsStorage = MockUserCredentialsFetching()
    let favoriteBreedsSyncService = MockFavoriteBreedsSyncService()
    let connectivityService = MockPhoneSignInConnectivityService()
    
    @Test("Handling fetched authenticated state of user")
    func fetchUserStateWhenAuthenticated() async {
        // given
        let store = TestStore(initialState: StartFeature.State()) {
            StartFeature()
        } withDependencies: {
            $0.userCredentialsFetchStorage = userCredentialsStorage
            $0.connectivityService = connectivityService
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        
        userCredentialsStorage.authenticatedValue = true
        // when
        await store.send(.fetchUserAuthState)
        // then
        await store.receive(.handleFetchedAuthState(userCredentialsStorage.authenticatedValue))
        await store.receive(.showDogsList) {
            $0.screenToShow = .dogsList
        }
        #expect(connectivityService.sendAuthCalled == 1)
        #expect(connectivityService.flag == true)
        #expect(favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivityCalled == 1)
    }
    
    @Test("Handling fetched non-authenticated state of user")
    func fetchUserStateWhenNotAuthenticated() async {
        // given
        let store = TestStore(initialState: StartFeature.State()) {
            StartFeature()
        } withDependencies: {
            $0.userCredentialsFetchStorage = userCredentialsStorage
            $0.connectivityService = connectivityService
            $0.favoriteBreedsSyncService = favoriteBreedsSyncService
        }
        // when
        await store.send(.fetchUserAuthState)
        // then
        await store.receive(.handleFetchedAuthState(userCredentialsStorage.authenticatedValue))
        await store.receive(.showSignIn) {
            $0.screenToShow = .signIn
        }
        #expect(connectivityService.sendAuthCalled == 1)
        #expect(connectivityService.flag == false)
        #expect(favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivityCalled == 0)
    }
}
