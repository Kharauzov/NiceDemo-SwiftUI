//
//  SignInViewContract.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import Foundation

protocol PhoneSignInConnectivityInterface {
    func sendAuth(flag: Bool)
}

extension WCService: PhoneSignInConnectivityInterface {}
