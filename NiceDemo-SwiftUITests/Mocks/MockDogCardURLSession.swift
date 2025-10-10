//
//  MockDogCardURLSession.swift
//  NiceDemo-SwiftUITests
//
//  Created by Serhii Kharauzov on 09.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockDogCardURLSession: DogCardURLSession {
    private(set) var fetchDataCalled = 0
    var shouldThrowError = false
    var data = Data()
    
    func data(from url: URL) async throws -> Data {
        fetchDataCalled += 1
        if shouldThrowError {
            struct AnyError: Error {}
            throw AnyError()
        }
        return data
    }
}
