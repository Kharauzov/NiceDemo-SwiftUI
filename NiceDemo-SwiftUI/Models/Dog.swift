//
//  Dog.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 05.08.2025.
//

import Foundation

struct Dog: Identifiable, Hashable {
    var id: String {
        breed
    }
    let breed: String
    let subbreeds: [String]?
    var isFavorite: Bool = false
}
