//
//  GalleryCellView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 15.08.2025.
//

import SwiftUI
import CachedAsyncImage

struct GalleryCellView: View {
    let url: URL
    var onImageLoaded: (UIImage?) -> Void = { _ in }
    
    var body: some View {
        CachedAsyncImage(url: url, content: { image in
            image.resizable().scaledToFill()
                .task {
                    onImageLoaded(uiImage(from: image))
                }
        }, placeholder: {
            placeholder
        })
    }
    
    @ViewBuilder
    private var placeholder: some View {
        ZStack {
            Image("dog_placeholder")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.AppColors.white)
                .background(Color.AppColors.primary)
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.large)
                .tint(Color.AppColors.primary)
        }
    }
    
    func uiImage(from image: Image) -> UIImage? {
        let renderer = ImageRenderer(content: image)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
