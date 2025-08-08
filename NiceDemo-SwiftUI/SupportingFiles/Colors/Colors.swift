//
//  Colors.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .preferredColorScheme(.light)
        Preview()
            .preferredColorScheme(.dark)
    }
    
    struct Preview: View {
        var body: some View {
            ZStack {
                background
                content
            }
        }
        
        private var background: some View {
            Color.gray
                .edgesIgnoringSafeArea(.all)
        }
        
        private var content: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Section Title")
                    .font(.title3)
                    .foregroundColor(Color.AppColors.primary)
                Text("Lorem Ipsum 4:30 pm")
                    .font(.body)
                    .foregroundColor(Color.AppColors.black)
                Text("Wednesday Subtitle")
                    .font(.caption)
                    .foregroundColor(Color.AppColors.white)
            }
            .padding()
        }
    }
}
