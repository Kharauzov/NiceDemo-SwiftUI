//
//  UserCredentialsStoring.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import Foundation

protocol UserCredentialsStoring: AnyObject {
    var isUserAuthenticated: Bool { get set }
}

extension UserDefaultsLayer: UserCredentialsStoring {}
