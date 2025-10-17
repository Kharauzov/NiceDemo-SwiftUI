//
//  WatchSignInConnectivityInterface.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 20.08.2025.
//

import Foundation

protocol WatchSignInConnectivityInterface {
    var isAuthenticated: Bool { get }
    var authenticatedStream: AsyncStream<Bool>? { get }
}

extension WCService: WatchSignInConnectivityInterface {}
