//
//  MockDogGalleryNetwork.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 09.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockDogGalleryNetwork: DogGalleryNetwork {
    // Just for testing purpose
    struct AnyError: Error {}
    
    var shouldThrowError = false
    var response = GetBreedRandomImagesServerResponse(data: ["test1", "test2"])
    private(set) var getBreedRandomImagesCalled = 0
    private(set) var lastParams: (breed: String, amount: Int)?

    func getBreedRandomImages(_ breed: String, amount: Int) async throws -> GetBreedRandomImagesServerResponse {
        getBreedRandomImagesCalled += 1
        lastParams = (breed, amount)
        if shouldThrowError {
            throw AnyError()
        }
        return response
    }
}
