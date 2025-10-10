//
//  MockDogCardNetwork.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 09.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

final class MockDogCardNetwork: DogCardNetwork {
    private(set) var getBreedRandomImageCalled = 0
    var response = GetRandomDogImageServerResponse(data: nil)
    var shouldThrowError = false

    func getBreedRandomImage(_ breed: String) async throws -> GetRandomDogImageServerResponse {
        getBreedRandomImageCalled += 1
        if shouldThrowError {
            struct TestError: Error {}
            throw TestError()
        }
        return response
    }
}
