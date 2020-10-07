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
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var soundButton: UIButton!
    @IBOutlet private weak var mapView: GMSMapView!
    lazy private var popUpView = PopUpView()
    
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
        let cameraInfo = presenter.cameraInfo()
        let cameraData = CameraEntity()
        for (index, element) in coordinates.enumerated() {
            let marker = GMSMarker()
            marker.position.latitude = element.latitude
            marker.position.longitude = element.longitude
            
            if element.latitude == cameraInfo[index].latitude && element.longitude == cameraInfo[index].longitude {
                cameraData.address = cameraInfo[index].address
                cameraData.direction = cameraInfo[index].direction
                cameraData.speed = cameraInfo[index].speed
                cameraData.state = cameraInfo[index].state
                
                
                if cameraInfo[index].state == "on" {
                    marker.icon = UIImage(named: "Marker")
                } else {
                    marker.icon = UIImage(named: "Camera_off")
                }
            }
            
            marker.userData = cameraData
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
        
        guard let speed = manager.location?.speed else { return }
        speedLabel.text = speed < 0 ? "0 км/г" : "\(Int(speed * 3.6)) км/г"
        
        currentLocation = lastLocation.coordinate
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
        mapView.animate(toZoom: Constants.Default.zoom)
        locationManager.stopUpdatingLocation()
    }
}
