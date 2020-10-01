//
//  GMSCoordinateBounds.swift
//  FineDriver
//
//  Created by Вячеслав on 01.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit

extension GMSCoordinateBounds {
    convenience init(location: CLLocationCoordinate2D, radiusMeters: CLLocationDistance) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: radiusMeters, longitudinalMeters: radiusMeters)
        self.init(coordinate: region.northWest, coordinate: region.southEast)
    }
}

extension MKCoordinateRegion {
    var northWest: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude + span.latitudeDelta / 2, longitude: center.longitude - span.longitudeDelta / 2)
    }

    var southEast: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude - span.latitudeDelta / 2, longitude: center.longitude + span.longitudeDelta / 2)
    }
}
