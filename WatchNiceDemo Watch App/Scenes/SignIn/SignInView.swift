//
//  SignInView.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 18.08.2025.
//

import SwiftUI
import ComposableArchitecture

struct SignInView: View {
    @Bindable var store: StoreOf<SignInFeature>
    @EnvironmentObject private var appRootManager: AppRootManager
    
    init(store: StoreOf<SignInFeature>) {
        self.store = store
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
        .onAppear {
            store.send(.onAppear)
        }
        .onChange(of: store.shouldShowDogsList) { _, newValue in
            if newValue {
                showDogsListView()
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
    SignInView(store: Store(initialState: SignInFeature.State()) {
        SignInFeature()
    })
}
