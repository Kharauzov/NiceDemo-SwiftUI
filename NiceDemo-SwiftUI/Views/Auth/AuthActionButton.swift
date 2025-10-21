//
//  AuthActionButton.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import SwiftUI

struct AuthActionButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
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
}
