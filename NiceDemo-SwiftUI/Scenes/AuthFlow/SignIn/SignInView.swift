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
    @FocusState private var focusedField: TextFieldType?
    @EnvironmentObject private var appRootManager: AppRootManager
    @Environment(SimpleRouter<AuthRoutingDestination, AuthRoutingSheet>.self) private var router
    
    var body: some View {
        VStack(spacing: 20) {
            headerImage
            textFields
            Spacer()
            signInButton
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
            VStack {
                TextField("Email", text: $store.state.email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .font(.paperlogy(.regular, fontSize: 18))
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                Divider()
            }
            VStack {
                SecureField("Password", text: $store.state.password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .font(.paperlogy(.regular, fontSize: 18))
                    .focused($focusedField, equals: .password)
                Divider()
            }
        }
    }
    
    private var headerImage: some View {
        Image("dog")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.AppColors.primary)
            .padding(.top, 20)
            .padding(.bottom, 20)
    }
    
    private var signInButton: some View {
        Button(action: {
            store.send(.signButtonTap)
        }) {
            Text("Sign in")
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.AppColors.primary)
                .foregroundColor(Color.AppColors.white)
                .font(.paperlogy(.semibold, fontSize: 22))
                .cornerRadius(10)
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

extension SignInView {
    enum TextFieldType: Hashable {
        case email
        case password
    }
}
