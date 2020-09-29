//
//  MapViewController.swift
//  FineDriver
//
//  Created by THXDBase on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol MapViewControllerProtocol: class { }

class MapViewController: UIViewController {
    
    // MARK: - Private outlets
    @IBOutlet private weak var mapView: GMSMapView!
    
    
    // MARK: - Public property
    var presenter: MapPresenterProtocol?
    
    // MARK: - Private property
    private var locationManager = CLLocationManager()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setCurrentLocation()
        setupMapView()
        setupMarkers()
    }
    
    // MARK: - Private methods
    private func setCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func setupMapView() {
        mapView.isTrafficEnabled = true
    }
    
    private func setupMarkers() {
        guard let presenter = presenter else { return }
        let coordinates = presenter.markersLocation()
        
        for pinData in coordinates {
            let marker = GMSMarker()
            marker.position.latitude = pinData.latitude
            marker.position.longitude = pinData.longitude
            marker.icon = UIImage(named: "Group 39")
            marker.userData = pinData
            marker.map = mapView
        }
    }
}

// MARK: - Protocol methods
extension MapViewController: MapViewControllerProtocol { }

// MARK: - MapView Delegate methods
extension MapViewController: GMSMapViewDelegate {
    
}

// MARK: - LocationManager delegate method
extension MapViewController: CLLocationManagerDelegate {

}
