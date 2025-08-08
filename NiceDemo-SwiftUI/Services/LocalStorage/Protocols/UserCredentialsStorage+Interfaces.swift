//
//  UserCredentialsStorage+Interfaces.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import Foundation

protocol UserCredentialsFetching: AnyObject {
    var isUserAuthenticated: Bool { get }
}

protocol UserCredentialsUpdating: AnyObject {
    var isUserAuthenticated: Bool { get set }
}

extension UserCredentialsStorage: UserCredentialsFetching, UserCredentialsUpdating {}
