//
//  SignInView+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI

extension SignInView {
    @Observable
    class ViewModel {
        private let userCredentialsStorage: UserCredentialsUpdating
        private let connectivityService: PhoneSignInConnectivityInterface
        private let validator = Validator()
        var validationError: Validator.ValidationError?
        var showErrorAlert: Bool = false
        
        init(userCredentialsStorage: UserCredentialsUpdating, connectivityService: PhoneSignInConnectivityInterface) {
            self.userCredentialsStorage = userCredentialsStorage
            self.connectivityService = connectivityService
        }
        
        /// Returns value if it is valid. In other case returns nil.
        private func validateEmail(_ value: String?) -> String? {
            do {
                try validator.validateEmail(value)
            } catch let error as Validator.ValidationError {
                validationError = error
                showErrorAlert = true
                return nil
            } catch {
                return nil
            }
            return value
        }
        
        /// Returns value if it is valid. In other case returns nil.
        private func validatePassword(_ value: String?) -> String? {
            do {
                try validator.validatePassword(value)
            } catch let error as Validator.ValidationError {
                validationError = error
                showErrorAlert = true
                return nil
            } catch {
                return nil
            }
            return value
        }
        
        /// Returns `true` if sign-in was successful.
        func handleSignInButtonTap(_ email: String, password: String, _ completion: (Bool) -> Void) {
            // perform some validation here
            if let _ = validateEmail(email), let _ = validatePassword(password) {
                // validation passed
                // show loading...
                // perform some url request
                // hide loading..
                // handle result
                if true {
                    // we store, that user authenticated successfully
                    userCredentialsStorage.isUserAuthenticated = true
                    connectivityService.sendAuth(flag: true)
                    completion(true)
                } else {
                    // show appropriate UI, that error occured
                    completion(false)
                }
            }
            completion(false)
        }
    }
}
