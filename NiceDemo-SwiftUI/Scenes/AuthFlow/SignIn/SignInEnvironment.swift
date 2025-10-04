//
//  SignInEnvironment.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.10.2025.
//

import Foundation

struct SignInEnvironment {
    private let validator = Validator()
    
    func validateCredentials(_ credentials: SignInCredentials) throws -> SignInCredentials {
        try validator.validateEmail(credentials.email)
        try validator.validatePassword(credentials.password)
        return credentials
    }
}
