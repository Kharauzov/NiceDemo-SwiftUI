//
//  DogGalleryView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import SwiftUI
import CachedAsyncImage

struct DogGalleryView: View {
    @Namespace private var hero
    @State var viewModel: ViewModel
    @State private var selectedImageUrl: String? = nil
    @State private var showDetail = false
    private let heroTransitionDuration: CGFloat = AnimationDuration.microSlow.timeInterval
    
    init(dog: Dog) {
        let viewModel = ViewModel(dog: dog, networkService: DogsNetworkService())
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            gridView
            if let selectedImageUrl, showDetail {
                dogCardView(selectedImageUrl: selectedImageUrl)
            }
        }
        .animation(.bouncy, value: showDetail)
        .task {
            if viewModel.shouldLoadData {
                viewModel.shouldLoadData.toggle()
                viewModel.loadRandomImages()
            }
        }
        .background(.white)
    }
    
    @ViewBuilder func dogCardView(selectedImageUrl: String) -> some View {
        DogCardView(dog: viewModel.dog, mode: .fromGallery(selectedImageUrl), hero: hero, selectedImage: viewModel.downloadedImages[selectedImageUrl]) {
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
                    ForEach(viewModel.randomImagesUrls, id: \.self) { url in
                        VStack {
                            GalleryCellView(url: url) { loadedImage in
                                if let loadedImage {
                                    viewModel.downloadedImages[url.absoluteString] = loadedImage
                                }
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
                            selectedImageUrl = url.absoluteString
                            withAnimation(.easeIn(duration: heroTransitionDuration)) {
                                showDetail = true
                            }
                        }
                    }
                }
                          .padding(.top, 4)
            }
            .padding(EdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing))
        }
    }
    
    private func close() {
        withAnimation(.easeIn(duration: heroTransitionDuration)) {
            showDetail = false
        }
        selectedImageUrl = nil
    }
}

#Preview {
    DogGalleryView(dog: Dog(breed: "affenpinscher", subbreeds: [], isFavorite: false))
}
