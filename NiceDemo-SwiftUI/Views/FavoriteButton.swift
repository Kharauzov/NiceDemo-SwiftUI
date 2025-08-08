//
//  FavoriteButton.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import SwiftUI

struct FavoriteButton: View {
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Button {
                    onTap?()
                } label: {
                    Image("pawPrint")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.AppColors.white)
                        .padding(10)
                }
                .background(Color.AppColors.primary)
                .clipShape(RoundedRectangle(cornerRadius: geometry.size.width / 2))
            }
        }
    }
}

#Preview {
    FavoriteButton()
        .frame(width: 50, height: 50)
}
