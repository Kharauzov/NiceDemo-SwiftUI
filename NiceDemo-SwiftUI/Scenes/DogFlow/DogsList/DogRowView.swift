//
//  DogRowView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import SwiftUI

struct DogRowView: View {
    let dog: Dog
    var onTap: (() -> Void)?
    var onFavoriteTapped: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(dog.breed.capitalized)
                        .font(.paperlogy(.bold, fontSize: 18))
                    Group {
                        if let subbreeds = dog.subbreeds, subbreeds.count > 0 {
                            Text("Has subbreeds: (\(subbreeds.count))")
                        } else {
                            Text("No subbreeds")
                        }
                    }
                    .font(.paperlogy(.medium, fontSize: 16))
                }
                Spacer()
                if dog.isFavorite {
                    FavoriteButton {
                        onFavoriteTapped?()
                    }
                    .frame(width: 40, height: 40)
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            SeparatorView()
        }
        .padding(.horizontal, GridLayout.doubleRegularSpace)
        .padding(.vertical, GridLayout.regularSpace)
        .contentShape(Rectangle()) // Makes full row tappable
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    List {
        DogRowView(dog: Dog(breed: "Spaniel", subbreeds: nil, isFavorite: true))
        DogRowView(dog: Dog(breed: "Australian", subbreeds: ["Shepherd", "Cattle"]))
    }
    
}
