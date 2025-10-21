//
//  ForgotPasswordView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 05.08.2025.
//

import SwiftUI
import ComposableArchitecture

struct ForgotPasswordView: View {
    @Bindable var store: StoreOf<ForgotPasswordFeature>
    @FocusState private var emailFocusedField: TextFieldType?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            headerImage
            descriptionLabel
            emailTextField
            Spacer()
            submitButton
        }
        .padding()
        .inlineNavigationTitle(.recoveryPassword)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    store.send(.dismissTap)
                } label: {
                    Image(systemName: GlobalImages.leftChevron.rawValue)
                        .foregroundColor(Color.AppColors.primary)
                }
            }
        }
        .alert("", isPresented: $store.showErrorAlert) {
            Button("Okay", role: .cancel) {}
        } message: {
            Text(store.validationError?.localizedDescription ?? "")
        }
        .alert("", isPresented: $store.showSuccessAlert) {
            Button("Okay", role: .cancel) {
                store.send(.dismissTap)
            }
        } message: {
            Text(store.successAlertText)
        }
        .onChange(of: store.shouldDismiss) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    private var descriptionLabel: some View {
        Text("Enter your email and we’ll send you a link to get back to your account.")
            .font(.paperlogy(.regular, fontSize: 16))
            .foregroundColor(Color.AppColors.primary)
            .lineSpacing(GridLayout.regularSpace)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 50)
    }
    
    private var emailTextField: some View {
        VStack {
            TextField("Email", text: $store.email)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 12)
                .font(.paperlogy(.regular, fontSize: 18))
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .focused($emailFocusedField, equals: .email)
            Divider()
        }
    }
    
    private var headerImage: some View {
        Image("walkingWithDog")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.AppColors.primary)
            .padding(.top, 30)
            .padding(.bottom, 20)
    }
    
    private var submitButton: some View {
        Button(action: {
            store.send(.submitButtonTap(store.email))
        }) {
            Text("Submit")
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.AppColors.primary)
                .foregroundColor(Color.AppColors.white)
                .font(.paperlogy(.semibold, fontSize: 22))
                .cornerRadius(10)
        }
    }
}

extension ForgotPasswordView {
    enum TextFieldType: Hashable {
        case email
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView(store: Store(initialState: ForgotPasswordFeature.State()) {
            ForgotPasswordFeature()
        })
    }
}
