//
//  Constants.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

enum NetworkConstants {
    static let baseUrl = "https://dog.ceo/api"
}

enum GlobalImages: String {
    case leftChevron = "chevron.left"
}

enum ImageName: String {
    case favoriteOn = "pawPrintSelected"
    case favoriteOff = "pawPrintNotSelected"
    case heartOn = "heart.fill"
    case heartOff = "heart"
    case dog
    case walkingWithDog
    case checkmark
    case arrowsUpDown = "arrow.up.arrow.down"
    case pawPrint
    case arrowRight = "arrow.right"
}
