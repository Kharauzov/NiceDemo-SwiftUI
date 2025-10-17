//
//  PhotoLibraryService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.10.2025.
//

import Foundation
import Photos
import UIKit

class PhotoLibraryService {
    func requestAuthorization(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(status)
        }
    }
    
    func saveImageInPhotoAlbum(_ imageData: Data) {
        if let image = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
