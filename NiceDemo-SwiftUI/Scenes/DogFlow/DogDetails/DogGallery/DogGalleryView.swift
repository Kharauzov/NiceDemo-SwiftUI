//
//  DogGalleryView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import SwiftUI
import ComposableArchitecture
import CachedAsyncImage

struct DogGalleryView: View {
    @Namespace private var hero
    @Bindable var store: StoreOf<DogGalleryFeature>
    
    var body: some View {
        ZStack {
            gridView
            if let selectedImageUrl = store.selectedImageUrl, store.showDetail {
                dogCardView(selectedImageUrl: selectedImageUrl)
            }
        }
        .animation(.bouncy, value: store.showDetail)
        .task {
            await store.send(.onAppear).finish()
        }
        .background(.white)
    }
    
    @ViewBuilder func dogCardView(selectedImageUrl: String) -> some View {
        let cardStore = Store(initialState: DogCardFeature.State(
            dog: store.dog,
            mode: .fromGallery(selectedImageUrl),
            selectedImageData: store.downloadedImages[selectedImageUrl]?.pngData()
        )) {
            DogCardFeature()
        }
        DogCardView(
            store: cardStore,
            hero: hero
        ) {
            close()
        }
        .zIndex(1)
    }
    
    @ViewBuilder private var gridView: some View {
        let columns = 2
        let spacing: CGFloat = GridLayout.doubleRegularSpace
        let screenWidth = UIScreen.main.bounds.width
        let tileWidth = (screenWidth - spacing * 3) / CGFloat(columns)
        ScrollView {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns),
                          spacing: spacing) {
                    ForEach(store.randomImagesUrls, id: \.self) { url in
                        VStack {
                            GalleryCellView(url: url) { loadedImage in
                                store.send(.imageLoaded(urlString: url.absoluteString, image: loadedImage))
                            }
                            .frame(width: tileWidth, height: tileWidth)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            // bottom button (a source to morph from)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.clear)
                                .frame(height: 0)
                                .matchedGeometryEffect(id: DogDetailsView.AnimationGeometryEffect.cardControls(url.absoluteString).effectId, in: hero)
                        }
                        // whole card container (a source to morph from)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.AppColors.white)
                                .matchedGeometryEffect(id: DogDetailsView.AnimationGeometryEffect.cardContainer(url.absoluteString).effectId, in: hero)
                        )
                        .shadow(color: Color.AppColors.primary.opacity(0.0), radius: 0, x: 0, y: 0) // no shadow in grid
                        // photoTile itself (a source to morph from)
                        .matchedGeometryEffect(
                            id: DogDetailsView.AnimationGeometryEffect.cardImage(url.absoluteString).effectId,
                            in: hero
                        )
                        .onTapGesture {
                            store.send(.selectImage(urlString: url.absoluteString))
                        }
                    }
                }
                          .padding(.top, 4)
            }
            .padding(EdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing))
        }
    }
    
    private func close() {
        store.send(.closeDetail)
    }
}

#Preview {
    DogGalleryView(
        store: Store(initialState: DogGalleryFeature.State(dog: Dog(breed: "affenpinscher", subbreeds: [], isFavorite: false))) {
            DogGalleryFeature()
        }
    )
}

