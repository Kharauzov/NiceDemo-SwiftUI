//
//  SignInView.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 18.08.2025.
//

import SwiftUI

struct SignInView: View {
    @State var viewModel: ViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    
    init(connectivityService: WatchSignInConnectivityInterface = WCService.shared) {
        let viewModel = ViewModel(connectivityService: connectivityService)
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: GridLayout.doubleRegularSpace) {
            Image("pawPrint")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.AppColors.primary)
            Text("You're not signed in.")
                .foregroundStyle(Color.AppColors.white)
                .font(.paperlogy(.regular, fontSize: 20))
            Text("Please sign in on your iPhone.")
                .foregroundStyle(Color.AppColors.white)
                .font(.paperlogy(.regular, fontSize: 16))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .task {
            viewModel.connectivityService.isAuthenticatedChanged = { flag in
                if flag {
                    showDogsListView()
                }
            }
        }
    }
    
    func showDogsListView() {
        withAnimation(.spring()) {
            appRootManager.rootView = .dogsList
        }
    }
}

#Preview {
    SignInView()
}
