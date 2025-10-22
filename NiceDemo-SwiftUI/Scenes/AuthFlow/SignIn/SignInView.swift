//
//  SignInView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI
import AppRouter
import ComposableArchitecture

struct SignInView: View {
    @Bindable var store: StoreOf<SignInFeature>
    @FocusState private var focusedField: FocusedField?
    @EnvironmentObject private var appRootManager: AppRootManager
    @Environment(SimpleRouter<AuthRoutingDestination, AuthRoutingSheet>.self) private var router
    
    var body: some View {
        VStack(spacing: 20) {
            AuthHeaderImage(imageName: "dog")
            textFields
            Spacer()
            ActionButton(text: "Sign in") {
                store.send(.signButtonTap)
            }
            forgotPasswordButton
        }
        .padding()
        .inlineNavigationTitle(.signIn)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Skip") {
                    dismissKeyboard()
                    showDogsListView()
                }
                .foregroundColor(Color.AppColors.primary)
                .font(.paperlogy(.semibold, fontSize: 16))
            }
        }
        .alert("", isPresented: $store.showErrorAlert) {
            Button("Okay", role: .cancel) {}
        } message: {
            Text(store.validationError?.localizedDescription ?? "")
        }
        .onChange(of: store.shouldDismissKeyboard) { _, newValue in
            if newValue {
                dismissKeyboard()
            }
        }
        .onChange(of: store.shouldShowDogsList) { _, newValue in
            if newValue {
                showDogsListView()
            }
        }
        .onChange(of: store.shouldShowForgotPassword) { _, newValue in
            if newValue {
                showForgotPasswordView()
            }
        }
    }
    
    private var textFields: some View {
        Group {
            EmailTextField(text: $store.email, focusedType: .email, focusedField: $focusedField)
            SecureTextField(text: $store.password, focusedType: .password, focusedField: $focusedField)
        }
    }
    
    private var forgotPasswordButton: some View {
        Button(action: {
            store.send(.forgotPasswordButtonTap)
        }) {
            Text("Forgot password?")
                .font(.paperlogy(.medium, fontSize: 14))
                .foregroundColor(Color.AppColors.primary)
        }
    }
    
    func dismissKeyboard() {
        focusedField = nil
    }
    
    func showDogsListView() {
        withAnimation(.spring()) {
            appRootManager.rootView = .dogsList
        }
    }
    
    func showForgotPasswordView() {
        router.navigateTo(.forgotPassword)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(store: Store(initialState: SignInFeature.State()) {
            SignInFeature()
        })
    }
}
