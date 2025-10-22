//
//  EmptyView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import SwiftUI

struct EmptyView: View {
    var text = "No results"
    
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.paperlogy(.medium, fontSize: 20))
                .tint(Color.AppColors.black)
            Spacer()
        }
    }
}
