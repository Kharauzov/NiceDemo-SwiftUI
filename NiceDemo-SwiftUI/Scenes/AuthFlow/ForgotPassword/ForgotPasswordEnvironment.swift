//
//  ForgotPasswordEnvironment.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.10.2025.
//

import Foundation

struct ForgotPasswordEnvironment {
    private let validator = Validator()
    
    func validateEmail(_ value: String) throws -> String {
        try validator.validateEmail(value)
        return value
    }
}
