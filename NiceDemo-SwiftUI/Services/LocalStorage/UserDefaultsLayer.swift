//
//  UserDefaultsLayer.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import Foundation

/// Wrapper, responsible for storing/retrieving data using UserDefaults.
///
/// You shouldn't call its properties explicitly! Please use it as an abstract layer in
/// storage services via protocols.
class UserDefaultsLayer {

    init(userDefaultsSuiteName: String? = nil) {
        defaults = UserDefaults(suiteName: userDefaultsSuiteName)!
    }
    
    // MARK: Public Properties
    
    var isUserAuthenticated: Bool {
        get {
            return defaults.bool(forKey: GeneralKeys.isUserAuthenticated)
        } set {
            defaults.set(newValue, forKey: GeneralKeys.isUserAuthenticated)
        }
    }
    
    var favoriteDogBreeds: [String] {
        get {
            let array = defaults.array(forKey: GeneralKeys.favouriteDogBreed)
            return array as? [String] ?? []
        } set {
            defaults.set(newValue, forKey: GeneralKeys.favouriteDogBreed)
        }
    }
    
    // MARK: Private properties
    
    private let defaults: UserDefaults
}

extension UserDefaultsLayer {
    private struct GeneralKeys {
        static let isUserAuthenticated = "isUserAuthenticated"
        static let favouriteDogBreed = "favouriteDogBreeds"
    }
}
