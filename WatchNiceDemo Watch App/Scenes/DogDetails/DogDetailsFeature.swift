//
//  DogDetailsFeature.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct DogDetailsFeature: Reducer {
    @Dependency(\.favoriteStorage) var favoriteStorage
    @Dependency(\.favoriteBreedsSyncService) var favoriteBreedsSyncService
    @Dependency(\.dogDetailsNetwork) var networkService
    
    @ObservableState
    struct State: Equatable {
        var dog: Dog
        var loading = true
        var randomImageUrl: String?
        var favoriteButtonImageName = ""
        var zoom: CGFloat = 1.0
        var offset: CGSize = .zero
        var dragStart: CGSize = .zero
        
        init(dog: Dog) {
            self.dog = dog
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case loadRandomImage
        case randomImageLoaded(String?)
        case favoriteButtonTapped
        case imageZoomChanged(CGFloat)
        case imageOffsetChanged(CGSize)
        case dragStartChanged(CGSize)
        case resetImagePositionAndScale
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                setFavoriteButtonImageName()
                state.loading = true
                return .send(.loadRandomImage)
                
            case .loadRandomImage:
                return .run { [breed = state.dog.breed] send in
                    do {
                        let response = try await networkService.getBreedRandomImage(breed)
                        await send(.randomImageLoaded(response.data))
                    } catch {
                        await send(.randomImageLoaded(nil))
                    }
                }
                
            case let .randomImageLoaded(imageUrl):
                state.loading = false
                state.randomImageUrl = imageUrl
                return .none
                
            case .favoriteButtonTapped:
                if state.dog.isFavorite {
                    favoriteStorage.removeFromFavorite(state.dog)
                } else {
                    favoriteStorage.addToFavorite(state.dog)
                }
                state.dog.isFavorite.toggle()
                setFavoriteButtonImageName()
                favoriteBreedsSyncService.sendFavoriteBreedsViaConnectivity()
                return .none
                
            case let .imageZoomChanged(zoom):
                state.zoom = zoom
                return .none
                
            case let .imageOffsetChanged(offset):
                state.offset = offset
                return .none
                
            case let .dragStartChanged(dragStart):
                state.dragStart = dragStart
                return .none
                
            case .resetImagePositionAndScale:
                state.zoom = 1.0
                state.offset = .zero
                state.dragStart = .zero
                return .none
            }
            
            func setFavoriteButtonImageName() {
                state.favoriteButtonImageName = state.dog.isFavorite ? "heart.fill" : "heart"
            }
        }
    }
}
