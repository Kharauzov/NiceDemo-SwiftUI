//
//  DogDetailsView.swift
//  WatchNiceDemo Watch App
//
//  Created by Serhii Kharauzov on 19.08.2025.
//

import SwiftUI
import CachedAsyncImage

struct DogDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var index = 0
    @State private var isFavorite = false
    @State private var viewModel: ViewModel
    @State private var zoom: CGFloat = 1.0
    
    init(dog: Dog, favoriteStorage: DogDetailsFavoriteStorage = FavoriteDogBreedsStorage(), networkService: DogDetailsNetwork = DogsNetworkService()) {
        let viewModel = ViewModel(dog: dog, favoriteStorage: favoriteStorage, networkService: networkService)
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let randomImageUrl = viewModel.randomImageUrl, !viewModel.loading {
                    imageView(url: randomImageUrl)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    progressView
                }
                dismissButton
                    .frame(width: geometry.size.width)
                bottomControls
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .task {
            viewModel.loadRandomImage()
        }
    }
    
    private func imageView(url: String) -> some View {
        CachedAsyncImage(url: URL(string: url))
            .scaledToFill()
            .ignoresSafeArea()
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
    }
    
    private var progressView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .controlSize(.large)
            .tint(Color.AppColors.white)
    }
    
    private var dismissButton: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding([.top, .leading], GridLayout.regularSpace)
            Spacer()
        }
    }
    
    private var bottomControls: some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Button {
                    WKInterfaceDevice.current().play(.directionUp)
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
}

#Preview {
    DogDetailsView(dog: Dog(breed: "affenpinscher", subbreeds: nil))
}
