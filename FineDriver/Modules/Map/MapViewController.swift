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
            static let y: Double = -206
            static let height: Double = 156
            static let animationTime: Double = 0.3
            static let translationX: CGFloat = 0
            static let transationY: CGFloat = 256
        }
    }
    
    // MARK: - Private outlets
    @IBOutlet private weak var soundButton: UIButton!
    @IBOutlet private weak var mapView: GMSMapView!
    lazy var popUpView = PopUpView()
    
    // MARK: - Public property
    var presenter: MapPresenterProtocol?
    
    // MARK: - Private property
    private var locationManager = CLLocationManager()
    private var currentLocation = CLLocationCoordinate2D()
    
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
        
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: Constants.UkrainePosition.lat, longitude: Constants.UkrainePosition.long))
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        mapView.animate(toZoom: 7)
        
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
        let pinInfo = presenter.pinInfo()
        var pinData = PinEntity()
        for (index, element) in coordinates.enumerated() {
            let marker = GMSMarker()
            marker.position.latitude = element.latitude
            marker.position.longitude = element.longitude
            
            if element.latitude == pinInfo[index].lat && element.longitude == pinInfo[index].long {
                pinData.limitation = pinInfo[index].limitation
                pinData.adress = pinInfo[index].adress
                
                if pinInfo[index].isActive == true {
                    marker.icon = UIImage(named: "Group 39")
                }
            }
            
            marker.userData = pinData
            marker.map = mapView
        }
    }
    
    private func setupPopUpView() {
        popUpView = PopUpView(frame: CGRect(x: Constants.PopUp.x,
                                             y: Constants.PopUp.y,
                                             width: Double(mapView.frame.width),
                                             height: Constants.PopUp.height))
        view.addSubview(popUpView)
    }
    
    private func popUpAnimation(isShow: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.PopUp.animationTime) {
                if isShow {
                    self.setupPopUpView()
                    self.popUpView.transform = CGAffineTransform(translationX: Constants.PopUp.translationX, y: Constants.PopUp.transationY)
                } else {
                    self.popUpView.transform = .identity
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.PopUp.animationTime) {
                        self.popUpView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    // MARK: - Private action
    @IBAction private func didTapMenuButton(_ sender: Any) {
        presenter?.routeToMenu()
    }
    
    @IBAction private func didTapCurrentLocationButton(_ sender: Any) {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.latitude,
                                                           longitude: currentLocation.longitude))
        locationManager.startUpdatingLocation()
    }
    @IBAction private func didTapSoundButton(_ sender: Any) {
    }
    
}

// MARK: - Protocol methods
extension MapViewController: MapViewControllerProtocol { }

// MARK: - MapView Delegate methods
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       popUpAnimation(isShow: false)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        popUpAnimation(isShow: true)
        return nil
    }
}

// MARK: - LocationManager delegate method
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        currentLocation = lastLocation.coordinate
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
        mapView.animate(toZoom: Constants.Default.zoom)
        locationManager.stopUpdatingLocation()
    }
}
