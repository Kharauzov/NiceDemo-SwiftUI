//
//  DogsRouting.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import AppRouter

enum DogsRoutingDestination: DestinationType {
    static func from(path: String, fullPath: [String], parameters: [String : String]) -> DogsRoutingDestination? { nil }
    
    case dogDetails(Dog)
}

enum DogsRoutingSheet: SheetType {
    var id: Int { hashValue }
}
