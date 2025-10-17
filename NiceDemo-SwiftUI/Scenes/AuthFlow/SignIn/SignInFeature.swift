//
//  SignInFeature.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 03.10.2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SignInFeature: Reducer {
    @Dependency(\.userCredentialsUpdateStorage) var userCredentialsStorage
    @Dependency(\.connectivityService) var connectivityService
    private let environment = SignInEnvironment()
    
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var shouldDismissKeyboard = false
        var shouldShowDogsList = false
        var shouldShowForgotPassword = false
        var validationError: Validator.ValidationError?
        var showErrorAlert = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case signButtonTap
        case forgotPasswordButtonTap
        case successfulSignIn
        case handleValidation(Result<SignInCredentials, Error>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .signButtonTap:
                do {
                    let credentials = try environment.validateCredentials(
                        SignInCredentials(email: state.email, password: state.password)
                    )
                    return .send(.handleValidation(.success(credentials)))
                } catch {
                    return .send(.handleValidation(.failure(error)))
                }
            case .forgotPasswordButtonTap:
                state.shouldShowForgotPassword = true
                state.shouldDismissKeyboard = true
                return .none
            case .successfulSignIn:
                state.shouldDismissKeyboard = true
                state.shouldShowDogsList = true
                return .none
            case .binding:
                return .none
            case .handleValidation(.success):
                // we store that user authenticated successfully
                userCredentialsStorage.isUserAuthenticated = true
                connectivityService.sendAuth(flag: true)
                return .send(.successfulSignIn)
            case let .handleValidation(.failure(error)):
                if let error = error as? Validator.ValidationError {
                    state.validationError = error
                    state.showErrorAlert = true
                }
                return .none
            }
        }
    }
}
