//
//  DogDetailsView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import SwiftUI

struct DogDetailsView: View {
    @State var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SegmentTab = .single
    @Namespace private var underline
    
    init(dog: Dog) {
        let viewModel = ViewModel(dog: dog, favoriteStorage: FavoriteDogBreedsStorage())
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    @ViewBuilder private var content: some View {
        ZStack {
            if selectedTab == .single {
                DogCardView(dog: viewModel.dog)
                    .contentTransition(.opacity)           // cross-fade
            } else {
                DogGalleryView()
                    .contentTransition(.opacity)           // cross-fade
            }
        }
    }
    
    var body: some View {
        VStack {
            SegmentedUnderlineTabs(tabs: SegmentTab.allCases, selected: $selectedTab, underline: underline)
                .padding(.top, GridLayout.regularSpace)
            content
                .animation(.linear(duration: 0.33), value: selectedTab)
        }
        .frame(maxHeight: .infinity)
        .navigationTitle(viewModel.dog.breed.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.handleFavoriteButtonTap()
                } label: {
                    Image(viewModel.favoriteButtonImageName)
                        .renderingMode(.template)
                        .tint(Color.AppColors.primary)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.AppColors.primary)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.AppColors.white)
    }
}

extension DogDetailsView {
    enum SegmentTab: String, CaseIterable {
        case single
        case gallery
    }
}


#Preview {
    NavigationStack {
        DogDetailsView(dog: Dog(breed: "Shepard", subbreeds: ["Kelpie", "Shepherd", "Collie", "Cattle Dog", "Terrier", "Dingo"], isFavorite: false))
    }
}

#Preview {
    NavigationStack {
        DogDetailsView(dog: Dog(breed: "Shepard", subbreeds: [], isFavorite: false))
    }
}
