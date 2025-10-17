//
//  MockDogCardPhotoLibraryInterface.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import Foundation
import Photos
@testable import NiceDemo_SwiftUI

class MockDogCardPhotoLibraryInterface: DogCardPhotoLibraryInterface {
    private(set) var savedImageData: Data?
    private(set) var saveImageInPhotoAlbumCalled = 0
    var statusToReturn: PHAuthorizationStatus = .notDetermined
    private(set) var requestAuthorizationCalled = 0
    
    func saveImageInPhotoAlbum(_ imageData: Data) {
        saveImageInPhotoAlbumCalled += 1
        savedImageData = imageData
    }
    
    func requestAuthorization(completion: @escaping (PHAuthorizationStatus) -> Void) {
        requestAuthorizationCalled += 1
        completion(statusToReturn)
    }
}
