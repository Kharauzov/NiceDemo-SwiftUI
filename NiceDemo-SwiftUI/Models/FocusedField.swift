//
//  FocusedField.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import Foundation

enum FocusedField: String, Hashable {
    case email
    case password
    
    var placeholder: String {
        rawValue.capitalized
    }
}
