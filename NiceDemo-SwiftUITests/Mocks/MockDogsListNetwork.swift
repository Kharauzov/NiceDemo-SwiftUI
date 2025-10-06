//
//  MockDogsListNetwork.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 06.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockDogsListNetwork: DogsListNetwork {
    var getDogsCalled = 0
    var getDogsResponse = GetAllDogsServerResponse(data: [:])
    var shouldThrowError = false
    
    func getDogs() async throws -> GetAllDogsServerResponse {
        getDogsCalled += 1
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Smth went wrong"])
        }
        return getDogsResponse
    }
}
