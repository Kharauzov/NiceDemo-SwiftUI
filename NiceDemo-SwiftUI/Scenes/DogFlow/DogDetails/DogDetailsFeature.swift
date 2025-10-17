//
//  DogDetailsFeature.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import ComposableArchitecture

@Reducer
struct DogDetailsFeature {
    @Dependency(\.favoriteBreedsSyncService) var favoriteBreedsSync
    @Dependency(\.favoriteStorage) var favoriteStorage
    
    @ObservableState
    struct State: Equatable {
        var dog: Dog
        var selectedTab: DogDetailsView.SegmentTab = .single
        var favoriteButtonImageName = ""
        
        // Child features
        var dogCard: DogCardFeature.State
        var dogGallery: DogGalleryFeature.State

        init(dog: Dog, selectedTab: DogDetailsView.SegmentTab = .single) {
            self.dog = dog
            self.selectedTab = selectedTab
            self.dogCard = DogCardFeature.State(dog: dog, mode: .main)
            self.dogGallery = DogGalleryFeature.State(dog: dog)
        }
    }

    enum Action {
        case onAppear
        case setTab(DogDetailsView.SegmentTab)
        case favoriteTapped
        // Child actions
        case dogCard(DogCardFeature.Action)
        case dogGallery(DogGalleryFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.dogCard, action: \.dogCard) {
            DogCardFeature()
        }
        Scope(state: \.dogGallery, action: \.dogGallery) {
            DogGalleryFeature()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                setFavoriteButtonImageName()
                return .none

            case .setTab(let tab):
                state.selectedTab = tab
                return .none

            case .favoriteTapped:
                if state.dog.isFavorite {
                    favoriteStorage.removeFromFavorite(state.dog)
                } else {
                    favoriteStorage.addToFavorite(state.dog)
                }
                state.dog.isFavorite.toggle()
                // Keep child dog state in sync with current dog
                state.dogCard.dog = state.dog
                state.dogGallery.dog = state.dog
                setFavoriteButtonImageName()
                favoriteBreedsSync.sendFavoriteBreedsViaConnectivity()
                return .none
                
            case .dogCard:
                return .none

            case .dogGallery:
                return .none
            }
            
            func setFavoriteButtonImageName() {
                state.favoriteButtonImageName = state.dog.isFavorite ? ImageName.favoriteOn.rawValue : ImageName.favoriteOff.rawValue
            }
        }
    }
}
