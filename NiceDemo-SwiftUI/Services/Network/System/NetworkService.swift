//
//  NetworkService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

class NetworkService {
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }

    /// Create URLSession using buildRequest
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let (data, response) = try await requestSession(endpoint)
        if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw error
            }
        } else {
            throw NetworkError.invalidResponse
        }
    }
    
    /// Converts EndPointType to URLRequest
    func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        var request = URLRequest(url: endpoint.url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 120)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    fileprivate func requestSession(_ endpoint: Endpoint) async throws -> (Data, URLResponse) {
        let request = try self.buildRequest(from: endpoint)
        do {
            return try await session.data(for: request)
        } catch {
            let nsError = (error as NSError)
            throw NetworkError.custom(nsError.localizedDescription)
        }
    }
}
