//
//  StartView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI
import AppRouter

struct StartView: View {
    @State var viewModel: ViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    
    init(_ userCredentialsStorage: UserCredentialsFetching = UserCredentialsStorage()) {
#if os(watchOS)
        let viewModel = ViewModel(userCredentialsStorage: userCredentialsStorage)
#endif
#if os(iOS)
        let viewModel = ViewModel(userCredentialsStorage: userCredentialsStorage, connectivityService: WCService.shared)
#endif
        _viewModel = .init(wrappedValue: viewModel)
    }
    
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
            Task {
                if await viewModel.fetchUserAuthState() {
                    withAnimation(.spring()) {
                        appRootManager.rootView = .dogsList
                    }
                } else {
                    withAnimation(.spring()) {
                        appRootManager.rootView = .signIn
                    }
                }
            }
        }
    }
}

#Preview {
    StartView()
}
