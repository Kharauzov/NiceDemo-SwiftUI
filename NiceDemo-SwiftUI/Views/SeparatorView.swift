//
//  SeparatorView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import SwiftUI

struct SeparatorView: View {
    let height: CGFloat
    let color: Color
    
    init(height: CGFloat = 1, color: Color = Color.AppColors.black.opacity(0.2)) {
        self.height = height
        self.color = color
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

#Preview {
    SeparatorView()
}
