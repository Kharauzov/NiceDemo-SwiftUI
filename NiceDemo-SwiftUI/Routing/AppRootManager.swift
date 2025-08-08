//
//  AppRootManager.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 05.08.2025.
//

import Foundation

@Observable
final class AppRootManager: ObservableObject {
    
    var rootView: AppRootView = .start
    
    enum AppRootView {
        case start
        case signIn
        case dogsList
    }
}
