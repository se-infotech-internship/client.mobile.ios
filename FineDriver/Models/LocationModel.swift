//
//  LocationModel.swift
//  FineDriver
//
//  Created by Вячеслав on 20.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

struct LocationModel {
    var lat: Double
    var long: Double

    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }

    init?(json: [String: Any]?) {
        guard let results = json?["results"] as? [Any],
            let first = results[0] as? [String: Any],
            let geometry = first["geometry"] as? [String: Any],
            let location = geometry["location"] as? [String: Any],
            let latitude = location["lat"] as? Double,
            let longitude = location["lng"] as? Double else {
            return nil
        }
        self.lat = latitude
        self.long = longitude
    }
}
