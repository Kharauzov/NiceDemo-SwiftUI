//
//  SignInViewContract.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import Foundation

protocol WatchSignInConnectivityInterface {
    var isAuthenticated: Bool { get }
    var isAuthenticatedChanged: ((Bool) -> Void)? { get set }
}

extension WCService: WatchSignInConnectivityInterface {}
