//
//  BaseTextFieldStyle.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import SwiftUI

struct BaseTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.vertical, 12)
            .font(.paperlogy(.regular, fontSize: 18))
    }
}

extension View {
    func baseStyle() -> some View {
        modifier(BaseTextFieldStyle())
    }
}
