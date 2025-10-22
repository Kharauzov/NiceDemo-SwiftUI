//
//  DogCardView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import SwiftUI
import ComposableArchitecture

struct DogCardView: View {
    @Environment(\.dismiss) private var dismiss
    @Namespace private var defaultNamespace
    @Bindable var store: StoreOf<DogCardFeature>
    var hero: Namespace.ID?
    var onClose: (() -> Void)?
    let actionButtonHeight: CGFloat = 45

    init(store: StoreOf<DogCardFeature>, hero: Namespace.ID? = nil, onClose: (() -> Void)? = nil) {
        _store = Bindable(wrappedValue: store)
        self.hero = hero
        self.onClose = onClose
    }

    var body: some View {
        let screenHeight = UIScreen.main.bounds.height
        let cardHeight = store.mode == .main ? nil : screenHeight / 1.5
        ZStack {
            if store.mode != .main {
                ShadowBgDismissButton {
                    onClose?()
                }
            }
            VStack {
                imageView
                Spacer()
                if store.mode == .main {
                    SubbreedsView(data: store.dog.subbreeds ?? [])
                }
                nextImageButton
            }
            .frame(height: cardHeight)
            .background(cardContainerView)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: store.shadowColor, radius: 8, x: 0, y: 0)
            .padding(edgeInsets)
        }
        .task {
            await store.send(.onAppear).finish()
        }
        .alert("Image saved to gallery!", isPresented: $store.showSaveConfirmAlert) {
            Button("Okay", role: .cancel) { }
        }
        .alert("Can't save image to gallery. Access denied.", isPresented: $store.showDeniedGalleryAlert) {
            Button("Okay", role: .cancel) { }
        }
    }

    private var imageView: some View {
        DogCardImage(loadedImageData: store.loadedImageData)
            // photoTile itself (a source to morph to)
            .matchedGeometryEffect(
                id: DogDetailsView.AnimationGeometryEffect.cardImage(store.selectedImageUrl ?? "").effectId,
                in: hero ?? defaultNamespace
            )
            .padding(.bottom, GridLayout.commonSpace)
    }

    private var cardContainerView: some View {
        // whole card container (a source to morph to)
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.AppColors.white)
            .matchedGeometryEffect(
                id: DogDetailsView.AnimationGeometryEffect.cardContainer(store.selectedImageUrl ?? "").effectId,
                in: hero ?? defaultNamespace
            )
    }

    private var nextImageButton: some View {
        HStack(spacing: GridLayout.doubleRegularSpace) {
            if store.mode == .main {
                ActionButton(text: "Next", height: actionButtonHeight) {
                    store.send(.loadRandomImage)
                }
            }
            ActionButton(text: "Save", height: actionButtonHeight) {
                store.send(.saveTapped)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        // bottom button (morphs from placeholder in grid)
        .matchedGeometryEffect(
            id: DogDetailsView.AnimationGeometryEffect.cardControls(store.selectedImageUrl ?? "").effectId,
            in: hero ?? defaultNamespace
        )
    }
}

extension DogCardView {
    var edgeInsets: EdgeInsets {
        EdgeInsets(top: GridLayout.doubleRegularSpace,
                   leading: GridLayout.doubleRegularSpace,
                   bottom: GridLayout.fourthRegularSpace,
                   trailing: GridLayout.doubleRegularSpace)
    }

    enum ViewMode: Equatable {
        case main
        case fromGallery(String)
    }
}

#Preview {
    DogCardView(
        store: Store(initialState: DogCardFeature.State(
            dog: Dog(breed: "affenpinscher", subbreeds: ["Kelpie", "Shepherd", "Collie", "Cattle Dog", "Terrier", "Dingo"], isFavorite: false),
            mode: .fromGallery("https://images.dog.ceo/breeds/hound-blood/n02088466_6901.jpg"),
            isLoading: true,
            loadedImageData: nil,
            showSaveConfirmAlert: false,
            showDeniedGalleryAlert: false,
            selectedImageUrl: "https://images.dog.ceo/breeds/hound-blood/n02088466_6901.jpg"
        )) {
            DogCardFeature()
        }
    )
}

#Preview {
    DogCardView(
        store: Store(initialState: DogCardFeature.State(
            dog: Dog(breed: "affenpinscher", subbreeds: [], isFavorite: false),
            mode: .main
        )) {
            DogCardFeature()
        }
    )
}

