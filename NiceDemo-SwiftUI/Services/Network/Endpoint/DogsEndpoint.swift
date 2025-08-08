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
    
    var path: String {
        switch self {
        case .getBreeds:
            return "/breeds/list/all"
        case .getRandomPhoto(let breed):
            return "/breed/\(breed)/images/random"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        .request
    }
}
