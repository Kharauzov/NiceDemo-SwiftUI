//
//  UserCredentialsStorage.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import Foundation

/// Responsible for keeping user's credentials data.
/// If data supposed to be sensitive, please use Keychain for that.
/// I used 'storage' property what is an abstract class for any data storage. It might
/// be used for setting/retrieving data. One can replace it on any class that implements
/// 'UserCredentialsStorage' protocol. For demo purpose I'm using UserDefaults, but
/// it can be easily replaced on SQLite, Realm, CoreData etc.
class UserCredentialsStorage {
    private let storage: UserCredentialsStoring
    
    init(storage: UserCredentialsStoring = UserDefaultsLayer()) {
        self.storage = storage
    }
    
    // MARK: Public properties
    
    var isUserAuthenticated: Bool {
        get {
            return storage.isUserAuthenticated
        } set {
            storage.isUserAuthenticated = newValue
        }
    }
}
