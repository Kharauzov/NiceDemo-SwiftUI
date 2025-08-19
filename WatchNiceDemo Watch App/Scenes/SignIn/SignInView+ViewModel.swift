//
//  SignInView+ViewModel.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 18.08.2025.
//

import SwiftUI
import Combine

extension SignInView {
    @Observable
    class ViewModel {
        private var cancellables = Set<AnyCancellable>()
        var connectivityService: WatchSignInConnectivityInterface
        
        init(connectivityService: WatchSignInConnectivityInterface) {
            self.connectivityService = connectivityService
        }
    }
}
