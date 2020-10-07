//
//  CameraModel.swift
//  FineDriver
//
//  Created by Вячеслав on 06.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

final class CameraModel: Decodable {
    
    var address: String
    var latitude: Double
    var longitude: Double
    var direction: String?
    var speed: Int
    var state: String
    
    private enum CodingKeys: String, CodingKey {
        case address
        case latitude = "lat"
        case longitude = "lon"
        case direction = "dir"
        case speed
        case state
    }
}
