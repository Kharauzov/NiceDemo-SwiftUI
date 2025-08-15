//
//  DogGallery+ViewModel.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 11.08.2025.
//

import SwiftUI

extension DogGalleryView {
    @Observable
    class ViewModel {
        private(set) var dog: Dog
        private let networkService: DogGalleryNetwork
        private(set) var loading = true
        private(set) var data = [String]()
        private let amountToLoad = 10
        @ObservationIgnored
        var downloadedImages = [String: UIImage]()
        var shouldLoadData = true
        var randomImagesUrls: [URL] {
            data.compactMap({ URL(string: $0) })
        }
        
        init(dog: Dog, networkService: DogGalleryNetwork) {
            self.dog = dog
            self.networkService = networkService
        }
        
        @MainActor
        func loadRandomImages() {
            loading = true
            Task {
                do {
                    let response = try await networkService.getBreedRandomImages(dog.id, amount: amountToLoad)
                    data = response.data ?? []
                } catch _ {
                    // handle error here
                }
            }
        }
    }
}
