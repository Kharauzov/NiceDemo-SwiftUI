//
//  StartFeature.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 02.10.2025.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct StartFeature {
    @Dependency(\.connectivityService) var connectivityService
    @Dependency(\.userCredentialsStorage) var userCredentialsStorage
    @Dependency(\.favoriteBreedsSyncService) var favoriteBreedsSyncService
    
    enum ScreenToShow: Equatable {
        case dogsList
        case signIn
        case none
    }
    
    @ObservableState
    struct State: Equatable {
        var screenToShow: ScreenToShow = .none
    }
    
    enum Action: Equatable {
        case fetchUserAuthState
        case handleFetchedAuthState(Bool)
        case showDogsList
        case showSignIn
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchUserAuthState:
                return .run { send in
                    try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 second
                    let isUserAuthenticated = userCredentialsStorage.isUserAuthenticated
#if os(iOS)
                    connectivityService.sendAuth(flag: isUserAuthenticated)
                    if isUserAuthenticated {
                        favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivity()
                    }
#endif
                    await send(.handleFetchedAuthState(isUserAuthenticated))
                }
            case .handleFetchedAuthState(let flag):
                return flag ? .send(.showDogsList) : .send(.showSignIn)
            case .showDogsList:
                state.screenToShow = .dogsList
                return .none
            case .showSignIn:
                state.screenToShow = .signIn
                return .none
            }
        }
    }
}
