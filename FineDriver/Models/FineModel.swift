//
//  FineModel.swift
//  FineDriver
//
//  Created by Вячеслав on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

struct FineApiResponse {
    let countFines: Int
}

extension FineApiResponse: Decodable {
    
    private enum FineApiResponseCodingKeys: String, CodingKey {
        case countFines = "countFines" // TODO: - For example
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FineApiResponseCodingKeys.self)
        countFines = try container.decode(Int.self, forKey: .countFines)
    }
    
}

