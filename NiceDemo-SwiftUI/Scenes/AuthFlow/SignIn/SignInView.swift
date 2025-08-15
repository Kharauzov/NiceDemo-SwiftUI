//
//  SignInView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI
import AppRouter

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var emailFocusedField: TextFieldType?
    @FocusState private var passwordFocusedField: TextFieldType?
    @State var viewModel: ViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    @Environment(SimpleRouter<AuthRoutingDestination, AuthRoutingSheet>.self) private var router
    private var navigationTitle: String {
        "Sign In"
    }
    
    init(_ userCredentialsStorage: UserCredentialsUpdating = UserCredentialsStorage()) {
        let viewModel = ViewModel(userCredentialsStorage: userCredentialsStorage)
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            headerImage
            textFields
            Spacer()
            signInButton
            forgotPasswordButton
        }
        .padding()
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
        .alert("", isPresented: $viewModel.showErrorAlert) {
            Button("Okay", role: .cancel) {}
        } message: {
            Text(viewModel.validationError?.localizedDescription ?? "")
        }
    }
    
    private var textFields: some View {
        Group {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .font(.paperlogy(.regular, fontSize: 18))
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .focused($emailFocusedField, equals: .email)
                Divider()
            }
            VStack {
                SecureField("Password", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .font(.paperlogy(.regular, fontSize: 18))
                    .focused($passwordFocusedField, equals: .password)
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
            viewModel.handleSignInButtonTap(email, password: password) { success in
                if success {
                    dismissKeyboard()
                    showDogsListView()
                }
            }
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
            router.navigateTo(.forgotPassword)
            dismissKeyboard()
        }) {
            Text("Forgot password?")
                .font(.paperlogy(.medium, fontSize: 14))
                .foregroundColor(Color.AppColors.primary)
        }
    }
    
    func dismissKeyboard() {
        emailFocusedField = nil
        passwordFocusedField = nil
    }
    
    func showDogsListView() {
        withAnimation(.spring()) {
            appRootManager.rootView = .dogsList
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

extension SignInView {
    enum TextFieldType: Hashable {
        case email
        case password
    }
}
