//
//  SignInFeature.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 18.08.2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SignInFeature: Reducer {
    @Dependency(\.userCredentialsUpdateStorage) var userCredentialsStorage
    @Dependency(\.watchConnectivityService) var connectivityService
    
    @ObservableState
    struct State: Equatable {
        var isAuthenticated = false
        var shouldShowDogsList = false
    }
    
    enum Action: Equatable {
        case onAppear
        case authenticationStateChanged(Bool)
        case showDogsList
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    if let stream = connectivityService.authenticatedStream {
                        for await isAuthenticated in stream {
                            await send(.authenticationStateChanged(isAuthenticated))
                        }
                    }
                }
                
            case let .authenticationStateChanged(isAuthenticated):
                state.isAuthenticated = isAuthenticated
                userCredentialsStorage.isUserAuthenticated = isAuthenticated
                if isAuthenticated {
                    return .send(.showDogsList)
                }
                return .none
                
            case .showDogsList:
                state.shouldShowDogsList = true
                return .none
            }
        }
    }
}
