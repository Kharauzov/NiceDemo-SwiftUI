//
//  MockUserCredentialsFetching.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 03.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

final class MockUserCredentialsFetching: UserCredentialsFetching {
    var authenticatedValue: Bool = false
    
    var isUserAuthenticated: Bool {
        authenticatedValue
    }
}
