//
//  DogCardView+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import SwiftUI
import UIKit
import Photos

extension DogCardView {
    @Observable
    class ViewModel {
        private(set) var dog: Dog
        private(set) var favoriteButtonImageName = ""
        private let networkService: DogCardNetwork
        private(set) var loading = true
        var loadedImage: UIImage?
        var showSaveConfirmAlert = false
        var showDeniedGalleryAlert = false
        
        init(dog: Dog, networkService: DogCardNetwork) {
            self.dog = dog
            self.networkService = networkService
        }
        
        @MainActor
        func loadRandomImage() {
            loading = true
            Task {
                do {
                    let response = try await networkService.getBreedRandomImage(dog.breed)
                    if let image = try? await loadUIImage(from: response.data ?? "") {
                        loadedImage = image
                    }
                } catch _ {
                    // handle error here
                }
            }
        }
        
        @MainActor
        func loadImage(url: String) {
            Task {
                if let image = try? await loadUIImage(from: url) {
                    loadedImage = image
                }
            }
        }
        
        private func loadUIImage(from urlString: String) async throws -> UIImage? {
            guard let url = URL(string: urlString) else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)
            // Switch to main thread before creating UIImage if needed for UI use
            return await MainActor.run {
                UIImage(data: data)
            }
        }
        
        func saveImageToGallery() {
            guard let loadedImage = loadedImage else {
                return
            }
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized || status == .limited else {
                    self.showDeniedGalleryAlert = true
                    return
                }
                UIImageWriteToSavedPhotosAlbum(loadedImage, nil, nil, nil)
                self.showSaveConfirmAlert = true
            }
        }
    }
}
