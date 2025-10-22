//
//  DogDetailsView.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import SwiftUI
import CachedAsyncImage
import ComposableArchitecture

struct DogDetailsView: View {
    @Bindable var store: StoreOf<DogDetailsFeature>
    
    init(store: StoreOf<DogDetailsFeature>) {
        self.store = store
    }
    
    var body: some View {
        let screenSize = WKInterfaceDevice.current().screenBounds.size
        ZStack {
            if let randomImageUrl = store.randomImageUrl, !store.loading {
                imageView(url: randomImageUrl, size: screenSize)
                    .frame(width: screenSize.width, height: screenSize.height + 20)
                        .clipShape(Rectangle())
            } else {
                progressView
            }
            bottomControls
                .frame(width: screenSize.width, height: screenSize.height)
        }
        .task {
            store.send(.onAppear)
        }
    }
    
    private func imageView(url: String, size: CGSize) -> some View {
        CachedAsyncImage(url: URL(string: url))
            .scaledToFill()
            .ignoresSafeArea()
            .offset(store.offset)
            .scaleEffect(store.zoom)
            .focusable(true)
            .digitalCrownRotation(
                Binding(
                    get: { store.zoom },
                    set: { store.send(.imageZoomChanged($0)) }
                ),
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
                            width: store.dragStart.width + value.translation.width,
                            height: store.dragStart.height + value.translation.height
                        )
                        let clamped = clampedOffset(
                            proposed,
                            container: size,
                            zoom: store.zoom
                        )
                        store.send(.imageOffsetChanged(clamped))
                    }
                    .onEnded { _ in
                        store.send(.dragStartChanged(store.offset))
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.spring) {
                    _ = store.send(.resetImagePositionAndScale)
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
                    store.send(.resetImagePositionAndScale)
                    store.send(.loadRandomImage)
                } label: {
                    Label("Next", systemImage: ImageName.arrowRight.rawValue)
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
                    store.send(.favoriteButtonTapped)
                } label: {
                    Image(systemName: store.favoriteButtonImageName)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(10)
                }
                .buttonStyle(.plain)
                .background(.ultraThinMaterial, in: Capsule())
                .contentShape(Capsule())
            }
            .padding(.horizontal, 10)
            .padding(.bottom, GridLayout.trippleRegularSpace)
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
    
}

#Preview {
    DogDetailsView(store: Store(initialState: DogDetailsFeature.State(dog: Dog(breed: "affenpinscher", subbreeds: nil))) {
        DogDetailsFeature()
    })
}
