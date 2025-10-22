//
//  EmailTextField.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var text: String
    var focusedType: FocusedField
    @FocusState.Binding var focusedField: FocusedField?
    
    var body: some View {
        FieldContainer {
            TextField(focusedType.placeholder, text: $text)
                .baseStyle()
                .focused($focusedField, equals: focusedField)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
        }
    }
}
