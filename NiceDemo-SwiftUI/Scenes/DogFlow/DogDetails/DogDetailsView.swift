//
//  DogDetailsView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 07.08.2025.
//

import SwiftUI
import ComposableArchitecture

struct DogDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Namespace private var underline
    @Bindable var store: StoreOf<DogDetailsFeature>

    init(store: StoreOf<DogDetailsFeature>) {
        self.store = store
    }

    @ViewBuilder private var content: some View {
        GeometryReader { geo in
            let width = geo.size.width
            ZStack(alignment: .leading) {
                DogCardView(store: store.scope(state: \.dogCard, action: \.dogCard))
                    .offset(x: store.selectedTab == .single ? 0 : -width) // slide left when hidden
                    .zIndex(store.selectedTab == .single ? 1 : 0)
                    .allowsHitTesting(store.selectedTab == .single)
                    .padding(.bottom, GridLayout.commonSpace)
                DogGalleryView(store: store.scope(state: \.dogGallery, action: \.dogGallery))
                    .offset(x: store.selectedTab == .gallery ? 0 : width) // slide right when hidden
                    .zIndex(store.selectedTab == .gallery ? 1 : 0)
                    .allowsHitTesting(store.selectedTab == .gallery)
            }
            .clipped()
            .animation(.easeInOut(duration: AnimationDuration.macroFast.timeInterval), value: store.selectedTab)
            .ignoresSafeArea()
        }
    }

    var body: some View {
        VStack {
            SegmentedUnderlineTabs(tabs: SegmentTab.allCases, selected: Binding(
                get: { store.selectedTab },
                set: { store.send(.setTab($0)) }
            ), underline: underline)
            .padding(.top, GridLayout.regularSpace)
            content
        }
        .frame(maxHeight: .infinity)
        .inlineNavigationTitle(store.dog.breed.capitalized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    store.send(.favoriteTapped)
                } label: {
                    Image(store.favoriteButtonImageName)
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
        .task {
            await store.send(.onAppear).finish()
        }
    }
}

#Preview {
    NavigationStack {
        DogDetailsView(
            store: Store(initialState: DogDetailsFeature.State(
                dog: Dog(breed: "Shepard", subbreeds: ["Kelpie", "Shepherd", "Collie", "Cattle Dog", "Terrier", "Dingo"], isFavorite: false)
            )) {
                DogDetailsFeature()
            }
        )
    }
}

#Preview {
    NavigationStack {
        DogDetailsView(
            store: Store(initialState: DogDetailsFeature.State(
                dog: Dog(breed: "affenpinscher", subbreeds: [], isFavorite: false)
            )) {
                DogDetailsFeature()
            }
        )
    }
}
