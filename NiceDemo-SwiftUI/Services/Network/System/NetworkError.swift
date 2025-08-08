//
//  NetworkError.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidResponseDataType
    case invalidResponse
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidResponseDataType:
            return "Response's data format is different from expected."
        case .invalidResponse:
            return "Invalid response."
        case .custom(let value):
            return value
        }
    }
}
