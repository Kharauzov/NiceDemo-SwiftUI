//
//  ForgotPasswordView+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 08.08.2025.
//

import Foundation

extension ForgotPasswordView {
    @Observable
    class ViewModel {
        private let validator = Validator()
        var validationError: Validator.ValidationError?
        var showErrorAlert: Bool = false
        var showSuccessAlert: Bool = false
        
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
        
        func handleSubmitButtonTap(_ email: String) {
            // perform some validation here
            if let _ = validateEmail(email) {
                // validation passed
                // show loading...
                // perform some url request
                // hide loading..
                // handle result
                showSuccessAlert = true
            }
        }
    }
}
