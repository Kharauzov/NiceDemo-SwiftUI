//
//  FavoriteDogBreedsStoring.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

protocol FavoriteDogBreedsStoring: AnyObject {
    var favoriteDogBreeds: [String] { get set }
}

extension UserDefaultsLayer: FavoriteDogBreedsStoring {}
