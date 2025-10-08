//
//  DogDetailsView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import SwiftUI
import ComposableArchitecture

struct DogDetailsView: View {
    @State var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SegmentTab = .single
    @Namespace private var underline
    private let dogGalleryStore: StoreOf<DogGalleryFeature>
    
    init(dog: Dog) {
        let viewModel = ViewModel(dog: dog, favoriteStorage: FavoriteDogBreedsStorage(), favoriteBreedsSyncService: FavoriteBreedsSyncService())
        _viewModel = .init(wrappedValue: viewModel)
        dogGalleryStore = Store(initialState: DogGalleryFeature.State(dog: dog)) {
            DogGalleryFeature()
        }
    }
    
    @ViewBuilder private var content: some View {
        GeometryReader { geo in
                let width = geo.size.width
                ZStack(alignment: .leading) {
                    DogCardView(dog: viewModel.dog, mode: .main)
                        .offset(x: selectedTab == .single ? 0 : -width) // slide left when hidden
                        .zIndex(selectedTab == .single ? 1 : 0)
                        .allowsHitTesting(selectedTab == .single)
                        .padding(.bottom, GridLayout.commonSpace)
                    DogGalleryView(store: dogGalleryStore)
                        .offset(x: selectedTab == .gallery ? 0 : width) // slide right when hidden
                        .zIndex(selectedTab == .gallery ? 1 : 0)
                        .allowsHitTesting(selectedTab == .gallery)
                }
                .clipped()
                .animation(.easeInOut(duration: AnimationDuration.macroFast.timeInterval), value: selectedTab)
                .ignoresSafeArea()
            }
    }
    
    var body: some View {
        VStack {
            SegmentedUnderlineTabs(tabs: SegmentTab.allCases, selected: $selectedTab, underline: underline)
                .padding(.top, GridLayout.regularSpace)
            content
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
                    Image(systemName: GlobalImages.leftChevron.rawValue)
                        .foregroundColor(Color.AppColors.primary)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.AppColors.white)
    }
}

#Preview {
    NavigationStack {
        DogDetailsView(dog: Dog(breed: "Shepard", subbreeds: ["Kelpie", "Shepherd", "Collie", "Cattle Dog", "Terrier", "Dingo"], isFavorite: false))
    }
}

#Preview {
    NavigationStack {
        DogDetailsView(dog: Dog(breed: "affenpinscher", subbreeds: [], isFavorite: false))
    }
}
