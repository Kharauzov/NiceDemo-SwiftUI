//
//  DogCardFeature.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import ComposableArchitecture
import Photos

@Reducer
struct DogCardFeature {
    @Dependency(\.dogCardNetwork) var networkService
    @Dependency(\.dogCardURLSession) var urlSession
    @Dependency(\.photoLibraryService) var photoLibraryService
    
    enum CancelID {
        case loadImage
    }
    
    @ObservableState
    struct State: Equatable {
        var dog: Dog
        var mode: DogCardView.ViewMode
        var isLoading: Bool = true
        var loadedImageData: Data? = nil
        var showSaveConfirmAlert = false
        var showDeniedGalleryAlert = false
        // Inputs when launched from gallery
        var selectedImageUrl: String? = nil
        // Gesture state
        var scale: CGFloat = 1.0
        var lastScale: CGFloat = 1.0
        var offset: CGSize = .zero
        var lastOffset: CGSize = .zero
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case loadRandomImage
        case loadImage(url: String)
        case handleRandomImage(Result<GetRandomDogImageServerResponse, Error>)
        case imageDataLoaded(Data?)
        case saveTapped
        case savedToPhotos
        case saveDenied
        // Gesture actions
        case scaleChanged(CGFloat)
        case scaleEnded
        case offsetChanged(CGSize)
        case offsetEnded
        case resetImagePositionAndScale
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
                    if state.loadedImageData != nil {
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
                    let data = try await urlSession.data(from: url)
                    await send(.imageDataLoaded(data))
                } catch: { _, send in
                    await send(.imageDataLoaded(nil))
                }
                    .cancellable(id: CancelID.loadImage, cancelInFlight: true)
                
            case .imageDataLoaded(let data):
                state.loadedImageData = data
                state.isLoading = false
                return .none
                
            case .saveTapped:
                guard let loadedImageData = state.loadedImageData else { return .none }
                return .run { send in
                    let status = await withCheckedContinuation { continuation in
                        photoLibraryService.requestAuthorization { status in
                            continuation.resume(returning: status)
                        }
                    }
                    guard status == .authorized || status == .limited else {
                        await send(.saveDenied)
                        return
                    }
                    photoLibraryService.saveImageInPhotoAlbum(loadedImageData)
                    await send(.savedToPhotos)
                }
            case .savedToPhotos:
                state.showSaveConfirmAlert = true
                return .none
                
            case .saveDenied:
                state.showDeniedGalleryAlert = true
                return .none
                
            case .scaleChanged(let newScale):
                state.scale = max(newScale, 1.0)
                return .none
                
            case .scaleEnded:
                state.lastScale = state.scale
                return .none
                
            case .offsetChanged(let newOffset):
                state.offset = newOffset
                return .none
                
            case .offsetEnded:
                state.lastOffset = state.offset
                return .none
                
            case .resetImagePositionAndScale:
                state.offset = .zero
                state.lastOffset = .zero
                state.scale = 1.0
                state.lastScale = 1.0
                return .none
            }
        }
    }
}

