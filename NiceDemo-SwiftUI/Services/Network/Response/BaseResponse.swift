//
//  BaseResponse.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

class BaseResponse: Codable {
    let status: String
    let error: String?
    
    init(status: String, error: String?) {
        self.status = status
        self.error = error
    }
}
