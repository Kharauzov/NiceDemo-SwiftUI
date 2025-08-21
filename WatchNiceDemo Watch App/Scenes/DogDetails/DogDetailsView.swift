//
//  DogDetailsView.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import SwiftUI
import CachedAsyncImage

struct DogDetailsView: View {
    @State private var index = 0
    @State private var isFavorite = false
    @State private var viewModel: ViewModel
    @State private var zoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var dragStart: CGSize = .zero
    
    init(dog: Dog, favoriteStorage: DogDetailsFavoriteStorage = FavoriteDogBreedsStorage(), networkService: DogDetailsNetwork = DogsNetworkService()) {
        let viewModel = ViewModel(dog: dog, favoriteStorage: favoriteStorage, networkService: networkService, favoriteBreedsSyncService: FavoriteBreedsSyncService())
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let randomImageUrl = viewModel.randomImageUrl, !viewModel.loading {
                    imageView(url: randomImageUrl, size: geometry.size)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    progressView
                }
                bottomControls
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .task {
            viewModel.loadRandomImage()
        }
    }
    
    private func imageView(url: String, size: CGSize) -> some View {
        CachedAsyncImage(url: URL(string: url))
            .scaledToFill()
            .ignoresSafeArea()
            .offset(offset)
            .scaleEffect(zoom)
            .focusable(true)
            .digitalCrownRotation(
                $zoom,
                from: 1.0,
                through: 3.0,
                by: 0.1,
                sensitivity: .medium,
                isContinuous: false,
                isHapticFeedbackEnabled: true
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let proposed = CGSize(
                            width: dragStart.width + value.translation.width,
                            height: dragStart.height + value.translation.height
                        )
                        offset = clampedOffset(
                            proposed,
                            container: size,
                            zoom: zoom
                        )
                    }
                    .onEnded { _ in
                        dragStart = offset
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.spring) {
                    resetImagePositionAndScale()
                }
            }
            .clipped()
    }
    
    private var progressView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .controlSize(.large)
            .tint(Color.AppColors.white)
    }
    
    private var bottomControls: some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Button {
                    WKInterfaceDevice.current().play(.directionUp)
                    resetImagePositionAndScale()
                    viewModel.loadRandomImage()
                } label: {
                    Label("Next", systemImage: "arrow.right")
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(minWidth: 90)
                }
                .buttonStyle(.plain)
                .background(.ultraThinMaterial, in: Capsule())
                .contentShape(Capsule())
                
                Button {
                    WKInterfaceDevice.current().play(.success)
                    viewModel.handleFavoriteButtonTap()
                } label: {
                    Image(systemName: viewModel.favoriteButtonImageName)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(10)
                }
                .buttonStyle(.plain)
                .background(.ultraThinMaterial, in: Capsule())
                .contentShape(Capsule())
            }
            .padding(.horizontal, 10)
            .padding(.bottom, GridLayout.doubleRegularSpace)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    /// Clamp pan so the image can't be dragged beyond its visible bounds.
    private func clampedOffset(_ proposed: CGSize, container: CGSize, zoom: CGFloat) -> CGSize {
        // When zoom == 1, no panning allowed.
        guard zoom > 1 else { return .zero }
        
        // Assuming the image fits inside the container (scaledToFit),
        // the extra "virtual size" you can pan equals container * (zoom - 1).
        let maxX = (container.width  * (zoom - 1)) / 2
        let maxY = (container.height * (zoom - 1)) / 2
        
        let x = min(max(proposed.width,  -maxX), maxX)
        let y = min(max(proposed.height, -maxY), maxY)
        return CGSize(width: x, height: y)
    }
    
    private func resetImagePositionAndScale() {
        zoom = 1
        offset = .zero
        dragStart = .zero
    }
}

#Preview {
    DogDetailsView(dog: Dog(breed: "affenpinscher", subbreeds: nil))
}
