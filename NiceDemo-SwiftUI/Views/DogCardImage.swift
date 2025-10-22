//
//  DogCardImage.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 22.10.2025.
//

import SwiftUI

struct DogCardImage: View {
    private let showLoadingWhenNoData: Bool
    private let loadedImageData: Data?

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
        
    init(showLoadingWhenNoData: Bool = true, loadedImageData: Data?) {
        self.showLoadingWhenNoData = showLoadingWhenNoData
        self.loadedImageData = loadedImageData
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .overlay {
                    if let imageData = loadedImageData, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(scale)
                            .offset(offset)
                            .gesture(
                                SimultaneousGesture(
                                    MagnifyGesture()
                                        .onChanged { value in
                                            let newScale = max(lastScale * value.magnification, 1)
                                            scale = newScale
                                        }
                                        .onEnded { _ in
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                lastScale = scale
                                            }
                                        },
                                    DragGesture()
                                        .onChanged { value in
                                            let newOffset = CGSize(
                                                width: lastOffset.width + value.translation.width,
                                                height: lastOffset.height + value.translation.height
                                            )
                                            offset = newOffset
                                        }
                                        .onEnded { _ in
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                lastOffset = offset
                                            }
                                        }
                                )
                            )
                    } else {
                        if showLoadingWhenNoData {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.large)
                                .tint(Color.AppColors.white)
                        }
                    }
                }
                .foregroundStyle(Color.AppColors.primary.opacity(0.5))
                .clipShape(.rect(
                    topLeadingRadius: 14,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 14
                ))
        }
        .onTapGesture(count: 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                resetImagePositionAndScale()
            }
        }
        .onChange(of: loadedImageData) { _, _ in
            // When the image data changes, reset zoom/pan.
            // You can add a nil-check if you only want to reset on non-nil.
            resetImagePositionAndScale()
        }
    }
    
    private func resetImagePositionAndScale() {
        offset = .zero
        lastOffset = .zero
        scale = 1.0
        lastScale = 1.0
    }
}
