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
    
    private enum Constants {
        
        enum Default {
            static let zoom: Float = 17
        }
            
        enum UkrainePosition {
            static let lat: Double = 49.0392207
            static let long: Double = 29.8098225
            static let zoom: Float = 7
        }
        
        enum PopUp {
            static let x: Double = 0
            static let y: Double = 50
            static let height: Double = 156
        }
    }
    
    // MARK: - Private outlets
    @IBOutlet private weak var mapView: GMSMapView!
    
    // MARK: - Public property
    var presenter: MapPresenterProtocol?
    
    // MARK: - Private property
    private var locationManager = CLLocationManager()
    private var currentLocation = CLLocation()
    
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
        let camera = GMSCameraPosition.camera(withLatitude: Constants.UkrainePosition.lat,
                                              longitude: Constants.UkrainePosition.long,
                                              zoom: Constants.UkrainePosition.zoom)
        mapView.camera = camera
        
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
    
    // MARK: - Private action
    @IBAction private func didTapInfoCameraButton(_ sender: Any) {
        let subView = PopUpView(frame: .init(x: Constants.PopUp.x,
                                             y: Constants.PopUp.y,
                                             width: Double(mapView.frame.width),
                                             height: Constants.PopUp.height))
        view.addSubview(subView)
    }
    
    @IBAction private func didTapMenuButton(_ sender: Any) {
        presenter?.routeToMenu()
    }
    
    @IBAction private func didTapCurrentLocationButton(_ sender: Any) {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude,
                                              zoom: Constants.Default.zoom)
        mapView.camera = camera
    }
}

// MARK: - Protocol methods
extension MapViewController: MapViewControllerProtocol { }

// MARK: - MapView Delegate methods
extension MapViewController: GMSMapViewDelegate { }

// MARK: - LocationManager delegate method
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        currentLocation = lastLocation
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude,
                                              zoom: Constants.Default.zoom)
        mapView.camera = camera
    }
}
