//
//  NiceDemo_SwiftUIApp.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI
import AppRouter

@main
struct NiceDemo_SwiftUIApp: App {
    @State private var authRouter = SimpleRouter<AuthRoutingDestination, AuthRoutingSheet>()
    @State private var dogsFlowRouter = SimpleRouter<DogsRoutingDestination, DogsRoutingSheet>()
    @State private var appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            rootContent
                .environment(appRootManager)
                .environment(authRouter)
                .environment(dogsFlowRouter)
        }
        
    }
    
    @ViewBuilder
    private var rootContent: some View {
        switch appRootManager.rootView {
        case .start:
            StartView()
        case .signIn:
            NavigationStack(path: $authRouter.path) {
                SignInView()
                    .navigationDestination(for: AuthRoutingDestination.self) { destination in
                        authDestinationView(for: destination)
                    }
            }
        case .dogsList:
            NavigationStack(path: $dogsFlowRouter.path) {
                DogsListView()
                    .navigationDestination(for: DogsRoutingDestination.self) { destination in
                        dogsFlowDestinationView(for: destination)
                    }
            }
        }
    }
}

@ViewBuilder
private func authDestinationView(for destination: AuthRoutingDestination) -> some View {
    switch destination {
    case .forgotPassword:
        ForgotPasswordView()
    }
}

@ViewBuilder
private func dogsFlowDestinationView(for destination: DogsRoutingDestination) -> some View {
    switch destination {
    case .dogDetails(let dog):
        DogDetailsView(dog: dog)
    }
}
