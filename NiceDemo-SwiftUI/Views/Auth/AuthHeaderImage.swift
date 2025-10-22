//
//  AuthHeaderImage.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import SwiftUI

struct AuthHeaderImage: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(Color.AppColors.primary)
            .padding(.top, 20)
            .padding(.bottom, 20)
    }
}
