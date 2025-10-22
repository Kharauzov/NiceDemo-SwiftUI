//
//  ActionButton.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import SwiftUI

struct ActionButton: View {
    let text: String
    let height: CGFloat
    let action: () -> Void
    private static let defaultHeight: CGFloat = 54
    
    init(text: String, height: CGFloat, action: @escaping () -> Void) {
        self.text = text
        self.height = height
        self.action = action
    }
    
    init(text: String, action: @escaping () -> Void) {
        self.init(text: text, height: Self.defaultHeight, action: action)
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .background(Color.AppColors.primary)
                .foregroundColor(Color.AppColors.white)
                .font(.paperlogy(.semibold, fontSize: 22))
                .cornerRadius(10)
        }
    }
}
