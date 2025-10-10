//
//  NiceDemo_SwiftUIApp.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI
import AppRouter
import ComposableArchitecture

@main
struct NiceDemo_SwiftUIApp: App {
    @State private var authRouter = SimpleRouter<AuthRoutingDestination, AuthRoutingSheet>()
    @State private var dogsFlowRouter = SimpleRouter<DogsRoutingDestination, DogsRoutingSheet>()
    @State private var appRootManager = AppRootManager()
    private let dogsListStore = Store(initialState: DogsListFeature.State()) {
        DogsListFeature()
    }
    
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
            StartView(store: Store(initialState: StartFeature.State()) {
                StartFeature()
            })
        case .signIn:
            NavigationStack(path: $authRouter.path) {
#if os(iOS)
                SignInView(store: Store(initialState: SignInFeature.State()) {
                    SignInFeature()
                })
                .navigationDestination(for: AuthRoutingDestination.self) { destination in
                    authDestinationView(for: destination)
                }
#elseif os(watchOS)
                SignInView()
#endif
            }
        case .dogsList:
            NavigationStack(path: $dogsFlowRouter.path) {
                DogsListView(store: dogsListStore)
                .navigationDestination(for: DogsRoutingDestination.self) { destination in
                    dogsFlowDestinationView(for: destination)
                }
            }
        }
    }
}

@ViewBuilder
private func authDestinationView(for destination: AuthRoutingDestination) -> some View {
#if os(iOS)
    switch destination {
    case .forgotPassword:
        ForgotPasswordView(store: Store(initialState: ForgotPasswordFeature.State()) {
            ForgotPasswordFeature()
        })
    }
#endif
}


@ViewBuilder
private func dogsFlowDestinationView(for destination: DogsRoutingDestination) -> some View {
    switch destination {
    case .dogDetails(let dog):
        #if os(iOS)
        DogDetailsView(
            store: Store(initialState: DogDetailsFeature.State(
                dog: dog
            )) {
                DogDetailsFeature()
            }
        )
        
#elseif os(watchOS)
        DogDetailsView(dog: dog)
        #endif
    }
}

let isRunningTests = NSClassFromString("XCTestCase") != nil
