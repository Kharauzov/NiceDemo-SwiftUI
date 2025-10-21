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
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack(spacing: 20) {
            AuthHeaderImage(imageName: "walkingWithDog")
            descriptionLabel
            EmailTextField(text: $store.email, focusedType: .email, focusedField: $focusedField)
            Spacer()
            AuthActionButton(text: "Submit") {
                store.send(.submitButtonTap(store.email))
            }
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
}

#Preview {
    NavigationStack {
        ForgotPasswordView(store: Store(initialState: ForgotPasswordFeature.State()) {
            ForgotPasswordFeature()
        })
    }
}
