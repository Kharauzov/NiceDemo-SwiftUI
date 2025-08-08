//
//  GetAllDogsServerResponse.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import Foundation

class GetAllDogsServerResponse: BaseResponse {
    var formattedData: [Dog]? {
        guard let data = data else { return nil }
        var dogs = [Dog]()
        data.forEach({ (item) in
            dogs.append(Dog(breed: item.key, subbreeds: item.value))
        })
        return dogs.sorted(by: {$0.breed < $1.breed})
    }
    
    private let data: [String: [String]]?

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try values.decode([String: [String]].self, forKey: .data)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
    }
}

extension GetAllDogsServerResponse {
    enum CodingKeys: String, CodingKey {
        case data = "message"
    }
}
