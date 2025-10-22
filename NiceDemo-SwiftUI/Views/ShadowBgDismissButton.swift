//
//  ShadowBgDismissButton.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 22.10.2025.
//

import SwiftUI

struct ShadowBgDismissButton: View {
    var handler: () -> Void
    
    var body: some View {
        VStack {
            Button {
                handler()
            } label: {
                Rectangle()
                    .fill(Color.AppColors.black.opacity(0.7))
            }
        }
        .buttonStyle(.plain)
        .frame(maxHeight: .infinity)
        .edgesIgnoringSafeArea(.horizontal)
        .edgesIgnoringSafeArea(.vertical)
    }
}
