//
//  SimpleDataLoader.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 09.10.2025.
//

import Foundation

class SimpleDataLoader: DogCardURLSession {
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func data(from url: URL) async throws -> Data {
        try await urlSession.data(from: url).0
    }
}
