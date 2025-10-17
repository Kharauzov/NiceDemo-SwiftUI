//
//  GetBreedRandomImagesServerResponse.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 11.08.2025.
//

import Foundation

class GetBreedRandomImagesServerResponse: BaseResponse {
    var data: [String]?
    
    init(data: [String]?) {
        self.data = data
        super.init(status: "", error: nil)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try values.decode([String].self, forKey: .data)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
    }
}
extension GetBreedRandomImagesServerResponse {
    enum CodingKeys: String, CodingKey {
        case data = "message"
    }
}

