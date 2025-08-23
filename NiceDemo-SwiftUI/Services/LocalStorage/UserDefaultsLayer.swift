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
            return defaults.bool(forKey: GeneralKeys.isUserAuthenticated.rawValue)
        } set {
            defaults.set(newValue, forKey: GeneralKeys.isUserAuthenticated.rawValue)
        }
    }
    
    var favoriteBreedsUpdatedAt: TimeInterval {
        get {
            return defaults.double(forKey: GeneralKeys.favoriteBreedsUpdatedAt.rawValue)
        } set {
            defaults.set(newValue, forKey: GeneralKeys.favoriteBreedsUpdatedAt.rawValue)
        }
    }
    
    var favoriteDogBreeds: [String] {
        get {
            let array = defaults.array(forKey: GeneralKeys.favouriteDogBreed.rawValue)
            return array as? [String] ?? []
        } set {
            defaults.set(newValue, forKey: GeneralKeys.favouriteDogBreed.rawValue)
        }
    }
    
    // MARK: Private properties
    
    private let defaults: UserDefaults
}

extension UserDefaultsLayer {
    private enum GeneralKeys: String {
        case isUserAuthenticated
        case favouriteDogBreed
        case favoriteBreedsUpdatedAt
    }
}
