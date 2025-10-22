//
//  SubbreedsView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 22.10.2025.
//

import SwiftUI

struct SubbreedsView: View {
    var data = [String]()
    
    var body: some View {
        if data.count > 0 {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(data, id: \.self) { breed in
                        Text(breed)
                            .font(.paperlogy(.semibold, fontSize: 15))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.AppColors.black, lineWidth: 2)
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        } else {
            Text("No subbreeds")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
}
