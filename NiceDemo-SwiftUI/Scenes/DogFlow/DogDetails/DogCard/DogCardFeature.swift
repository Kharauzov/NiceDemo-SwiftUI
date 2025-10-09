//
//  DogCardFeature.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import ComposableArchitecture
import UIKit
import Photos

@Reducer
struct DogCardFeature {
    @Dependency(\.dogCardNetwork) var networkService
    
    enum CancelID {
        case loadImage
    }
    
    @ObservableState
    struct State: Equatable {
        var dog: Dog
        var mode: DogCardView.ViewMode
        var isLoading: Bool = true
        var loadedImage: UIImage? = nil
        var showSaveConfirmAlert = false
        var showDeniedGalleryAlert = false
        
        // Inputs when launched from gallery
        var selectedImageUrl: String? = nil
        @ObservationStateIgnored
        var selectedImage: UIImage? = nil
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case loadRandomImage
        case loadImage(url: String)
        case handleRandomImage(Result<GetRandomDogImageServerResponse, Error>)
        case imageDataLoaded(UIImage?)
        case saveTapped
        case savedToPhotos
        case saveDenied
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                switch state.mode {
                case .main:
                    return .send(.loadRandomImage)
                case .fromGallery(let url):
                    if let preselected = state.selectedImage {
                        state.loadedImage = preselected
                        state.isLoading = false
                        return .none
                    } else {
                        return .send(.loadImage(url: url))
                    }
                }
                
            case .loadRandomImage:
                state.isLoading = true
                let breed = state.dog.breed
                return .run { send in
                    let response = try await networkService.getBreedRandomImage(breed)
                    await send(.handleRandomImage(.success(response)))
                } catch: { error, send in
                    await send(.handleRandomImage(.failure(error)))
                }
                    .cancellable(id: CancelID.loadImage, cancelInFlight: true)
                
            case .handleRandomImage(.success(let response)):
                let urlString = response.data ?? ""
                guard !urlString.isEmpty else {
                    return .send(.imageDataLoaded(nil))
                }
                return .send(.loadImage(url: urlString))
                
            case .handleRandomImage(.failure):
                state.isLoading = false
                // handle error if needed
                return .none
                
            case .loadImage(let urlString):
                state.isLoading = true
                return .run { send in
                    guard let url = URL(string: urlString) else {
                        await send(.imageDataLoaded(nil))
                        return
                    }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let image = UIImage(data: data)
                    await send(.imageDataLoaded(image))
                } catch: { _, send in
                    await send(.imageDataLoaded(nil))
                }
                    .cancellable(id: CancelID.loadImage, cancelInFlight: true)
                
            case .imageDataLoaded(let image):
                state.loadedImage = image
                state.isLoading = false
                return .none
                
            case .saveTapped:
                guard let loadedImage = state.loadedImage else { return .none }
                return .run { send in
                    let status = await withCheckedContinuation { continuation in
                        PHPhotoLibrary.requestAuthorization { status in
                            continuation.resume(returning: status)
                        }
                    }
                    guard status == .authorized || status == .limited else {
                        await send(.saveDenied)
                        return
                    }
                    UIImageWriteToSavedPhotosAlbum(loadedImage, nil, nil, nil)
                    await send(.savedToPhotos)
                }
            case .savedToPhotos:
                state.showSaveConfirmAlert = true
                return .none
                
            case .saveDenied:
                state.showDeniedGalleryAlert = true
                return .none
            }
        }
    }
}

