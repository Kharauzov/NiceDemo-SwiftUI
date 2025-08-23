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
    private var favoriteButtonSize: CGFloat {
#if os(watchOS)
        35
#else
        40
#endif
    }
    private var horizontalPadding: CGFloat {
#if os(watchOS)
        0
#else
        GridLayout.doubleRegularSpace
#endif
    }
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
                    .frame(width: favoriteButtonSize, height: favoriteButtonSize)
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            #if os(iOS)
            SeparatorView()
            #endif
        }
        .padding(.horizontal, horizontalPadding)
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
