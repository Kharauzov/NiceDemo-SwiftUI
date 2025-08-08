//
//  Endpoint.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var url: URL { get }
}

extension Endpoint {
    var url: URL {
        baseURL.appendingPathComponent(path)
    }
    
    var baseURL: URL {
        guard let url = URL(string: NetworkConstants.baseUrl) else {
            fatalError("Base url could not be configured")
        }
        return url
    }
}
