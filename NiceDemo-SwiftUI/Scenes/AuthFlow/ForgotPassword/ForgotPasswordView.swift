//
//  ForgotPasswordView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 05.08.2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @FocusState private var emailFocusedField: TextFieldType?
    @State var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss
    private let successAlertText = "We sent you instructions for password recovery on your email."
    private var navigationTitle: String {
        "Recover password"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            headerImage
            descriptionLabel
            emailTextField
            Spacer()
            submitButton
        }
        .padding()
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: GlobalImages.leftChevron.rawValue)
                        .foregroundColor(Color.AppColors.primary)
                }
            }
        }
        .alert("", isPresented: $viewModel.showErrorAlert) {
            Button("Okay", role: .cancel) {}
        } message: {
            Text(viewModel.validationError?.localizedDescription ?? "")
        }
        .alert("", isPresented: $viewModel.showSuccessAlert) {
            Button("Okay", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(successAlertText)
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
            viewModel.handleSubmitButtonTap(email)
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
        ForgotPasswordView()
    }
}
