//
//  AuthRouting.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 05.08.2025.
//

import AppRouter

enum AuthRoutingDestination: DestinationType {
    static func from(path: String, fullPath: [String], parameters: [String : String]) -> AuthRoutingDestination? { nil }
    
    case forgotPassword
}

enum AuthRoutingSheet: SheetType {
    var id: Int { hashValue }
}
