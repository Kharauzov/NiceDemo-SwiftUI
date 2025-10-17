//
//  DogGalleryFeature.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 08.10.2025.
//

import ComposableArchitecture
import UIKit

@Reducer
struct DogGalleryFeature {
    @Dependency(\.dogGalleryNetwork) var networkService

    enum CancelID {
        case loadRandomImages
    }

    @ObservableState
    struct State: Equatable {
        var dog: Dog
        var isLoading = true
        var shouldLoadData = true
        var data: [String] = []
        @ObservationStateIgnored
        var downloadedImages: [String: UIImage] = [:]
        var selectedImageUrl: String? = nil
        var showDetail = false
        let amountToLoad = 10

        var randomImagesUrls: [URL] {
            data.compactMap { URL(string: $0) }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case loadRandomImages
        case handleFetchedImages(Result<GetBreedRandomImagesServerResponse, Error>)
        case imageLoaded(urlString: String, image: UIImage?)
        case selectImage(urlString: String)
        case closeDetail
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                guard state.shouldLoadData else { return .none }
                state.shouldLoadData = false
                return .send(.loadRandomImages)

            case .loadRandomImages:
                state.isLoading = true
                let breed = state.dog.id
                let amount = state.amountToLoad
                return .run { send in
                    let response = try await networkService.getBreedRandomImages(breed, amount: amount)
                    await send(.handleFetchedImages(.success(response)))
                } catch: { error, send in
                    await send(.handleFetchedImages(.failure(error)))
                }
                .cancellable(id: CancelID.loadRandomImages, cancelInFlight: true)

            case .handleFetchedImages(.success(let response)):
                state.data = response.data ?? []
                state.isLoading = false
                return .none

            case .handleFetchedImages(.failure):
                state.isLoading = false
                // TODO: add error handling if needed
                return .none

            case .imageLoaded(let urlString, let image):
                if let image {
                    state.downloadedImages[urlString] = image
                }
                return .none

            case .selectImage(let urlString):
                state.selectedImageUrl = urlString
                state.showDetail = true
                return .none

            case .closeDetail:
                state.showDetail = false
                state.selectedImageUrl = nil
                return .none
            }
        }
    }
}

