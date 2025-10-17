//
//  ForgotPasswordFeature.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.10.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ForgotPasswordFeature: Reducer {
    private let environment = ForgotPasswordEnvironment()
    
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        let successAlertText = "We sent you instructions for password recovery on your email."
        var shouldDismiss = false
        var validationError: Validator.ValidationError?
        var showErrorAlert: Bool = false
        var showSuccessAlert: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case dismissTap
        case submitButtonTap(String)
        case handleValidation(Result<String, Error>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .dismissTap:
                state.shouldDismiss = true
                return .none
            case .handleValidation(.success):
                state.showSuccessAlert = true
                return .none
            case let .handleValidation(.failure(error)):
                if let error = error as? Validator.ValidationError {
                    state.validationError = error
                    state.showErrorAlert = true
                }
                return .none
            case let .submitButtonTap(email):
                do {
                    let credentials = try environment.validateEmail(email)
                    return .send(.handleValidation(.success(credentials)))
                } catch {
                    return .send(.handleValidation(.failure(error)))
                }
            }
        }
    }
}
