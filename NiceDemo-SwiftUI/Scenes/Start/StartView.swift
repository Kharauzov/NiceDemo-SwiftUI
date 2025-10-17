//
//  StartView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import ComposableArchitecture
import SwiftUI
import AppRouter

struct StartView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    @Bindable var store: StoreOf<StartFeature>
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.large)
#if os(watchOS)
                .tint(Color.AppColors.primary)
#endif
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Color.AppColors.white)
        .onAppear {
            store.send(.fetchUserAuthState)
        }
        .onChange(of: store.screenToShow) { _, newScreen in
            switch newScreen {
            case .dogsList:
                withAnimation(.spring()) {
                    appRootManager.rootView = .dogsList
                }
            case .signIn:
                withAnimation(.spring()) {
                    appRootManager.rootView = .signIn
                }
            case .none:
                break
            }
        }
    }
}

#Preview {
    StartView(store: Store(initialState: StartFeature.State()) {
        StartFeature()
    })
}
