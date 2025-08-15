//
//  DogsEndpoint.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

enum DogsEndpoint: Endpoint {
    case getBreeds
    case getRandomPhoto(String)
    case getBreedRandomPhotos(String, Int)
    
    var path: String {
        switch self {
        case .getBreeds:
            return "/breeds/list/all"
        case .getRandomPhoto(let breed):
            return "/breed/\(breed)/images/random"
        case .getBreedRandomPhotos(let breed, let amount):
            return "/breed/\(breed)/images/random/\(amount)"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        .request
    }
}
