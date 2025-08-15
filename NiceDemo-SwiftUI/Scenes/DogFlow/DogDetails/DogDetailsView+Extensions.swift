//
//  DogDetailsView+Extensions.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 14.08.2025.
//

import SwiftUI

extension DogDetailsView {
    enum SegmentTab: String, CaseIterable {
        case single
        case gallery
    }
}

extension DogDetailsView {
    enum AnimationGeometryEffect {
        case cardControls(String)
        case cardContainer(String)
        case cardImage(String)
        
        var effectId: String {
            switch self {
            case .cardControls(let id):
                return "card-controls-\(id)"
            case .cardContainer(let id):
                return "card-container-\(id)"
            case .cardImage(let id):
                return "card-image-\(id)"
            }
        }
    }
}
