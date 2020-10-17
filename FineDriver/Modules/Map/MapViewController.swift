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

protocol MapViewControllerProtocol: class {
    func drawPath(from polyStr: String)
}

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
            static let y: Double = -156
            static let height: CGFloat = 156
            static let animationTime: Double = 0.3
            static let translationX: CGFloat = 0
        }
        
        enum Distance {
            static let longAway: Double = 700
            static let medium: Double = 200
            static let near: Double = 100
        }
    }
    
    // MARK: - Private outlets
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var soundButton: UIButton!
    @IBOutlet private weak var mapView: GMSMapView!
    
    private var popUpView: PopUpView?
    
    // MARK: - Public property
    var presenter: MapPresenterProtocol?
    
    // MARK: - Private property
    private var locationManager = CLLocationManager()
    private var currentLocation = CLLocationCoordinate2D()
    private var isCenterCamera = true
    private var isUpdateLocation = true
    private var isSoundMusic = false
    private var isCheckButtonSound = false
    private var oldPolylineArr = [GMSPolyline]()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setCurrentLocation()
        setupMapView()
        setupMarkers()
    }
    
    deinit {
        print("deinit MapViewController")
    }
    
    // MARK: - Private methods
    private func setCurrentLocation() {
        
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: Constants.UkrainePosition.lat, longitude: Constants.UkrainePosition.long))
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        mapView.animate(toZoom: Constants.UkrainePosition.zoom)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.activityType = .automotiveNavigation
    }
    
    private func setupMapView() {
        mapView.isTrafficEnabled = true
    }
    
    private func setupMarkers() {
        guard let presenter = presenter else { return }
        let coordinates = presenter.markersLocation()
        let cameraInfo = presenter.cameraInfo()
        var cameraData = CameraEntity()
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
                                            height: Double(Constants.PopUp.height)))
        view.addSubview(popUpView ?? UIView())
    }
    
    private func popUpAnimation(isShow: Bool = true) {
        
        UIView.animate(withDuration: Constants.PopUp.animationTime) {
            
            if isShow {
                self.setupPopUpView()
                self.popUpView?.transform = CGAffineTransform(translationX: Constants.PopUp.translationX,
                                                              y: self.view.safeAreaInsets.bottom + Constants.PopUp.height)
            } else {
                self.popUpView?.transform = .identity
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            if !isShow {
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.PopUp.animationTime) {
                    self.hidePopUp()
                }
            }
        }
    }
    
    private func hidePopUp() {
        popUpView?.removeFromSuperview()
    }
    
    private func soundOncomingCamera(forResource: String = "02869", withExtension: String = "mp3") {
        if isSoundMusic {
            presenter?.stopSound()
            presenter?.playSound(forResource: forResource, withExtension: withExtension)
        } else {
            presenter?.stopSound()
        }
    }
    
    // MARK: - Private action
    @IBAction private func didTapMenuButton(_ sender: Any) {
        presenter?.routeToMenu()
    }
    
    @IBAction private func didTapCurrentLocationButton(_ sender: Any) {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.latitude,
                                                           longitude: currentLocation.longitude))
        isCenterCamera = true
    }
    
    @IBAction private func didTapSoundButton(_ sender: Any) {
        
        isCheckButtonSound = !isCheckButtonSound
        
        if isCheckButtonSound {
            soundButton.setImage(UIImage(named: "Sound_off"), for: .normal)
            presenter?.stopSound()
        } else {
            soundButton.setImage(UIImage(named: "volume-2"), for: .normal)
            soundOncomingCamera()
        }
    }
}

// MARK: - Protocol methods
extension MapViewController: MapViewControllerProtocol {
    
    func drawPath(from polyStr: String) {
        
        DispatchQueue.main.async(execute: {
            let path = GMSPath(fromEncodedPath: polyStr)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5.0
            polyline.strokeColor = UIColor.systemBlue
            polyline.map = self.mapView
            
            self.oldPolylineArr.append(polyline)
            
            if self.oldPolylineArr.count > 0 {
                
                for polyline in self.oldPolylineArr {
                    polyline.map = nil
                }
            }
            self.oldPolylineArr.append(polyline)
            polyline.map = self.mapView
        })
    }
}

// MARK: - MapView Delegate methods
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        popUpAnimation(isShow: false)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        hidePopUp()
        guard let cameraInfo = marker.userData as? CameraEntity else { return nil }
        popUpAnimation()
        popUpView?.update(entity: cameraInfo, metersTo: 700)
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            isCenterCamera = false
        }
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        presenter?.fetchRoute(from: currentLocation, to: coordinate)
    }
}

// MARK: - LocationManager delegate method
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        // TODO: - Speed
        guard let speed = manager.location?.speed else { return }
        speedLabel.text = speed < 0 ? "0 км/г" : "\(Int(speed * 3.6)) км/г"
        
        if isCenterCamera {
            currentLocation = lastLocation.coordinate
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
            mapView.animate(toZoom: Constants.Default.zoom)
        }
        
        let startLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        guard let cameras = presenter?.cameraInfo() else { return }
        for (index, element) in cameras.enumerated() {
            guard let presenter = presenter else { return }
            
            let endLocation = CLLocation(latitude: presenter.model(index: index).latitude ?? 0, longitude: presenter.model(index: index).longitude ?? 0)
            let distance = startLocation.distance(from: endLocation)
            
            if isUpdateLocation {
                if distance.isLessThanOrEqualTo(Constants.Distance.longAway) {
                    isSoundMusic = true
                    isUpdateLocation = false
                    hidePopUp()
                    soundOncomingCamera()
                    popUpAnimation()
                    popUpView?.update(entity: element, metersTo: distance.binade)
                } else if distance.isLessThanOrEqualTo(10) {
                    isUpdateLocation = true
                    isSoundMusic = false
                }
            }
        }
        
        //    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        //
        //        if CLLocationManager.authorizationStatus() == .authorizedAlways {
        //
        //            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
        //
        //                let maxDistance = Constants.Distance.longAway
        //                let midDistance = Constants.Distance.medium
        //                let nearDistance = Constants.Distance.near
        //
        //                guard let cameras = presenter?.cameraInfo() else { return }
        //                for (_, element) in cameras.enumerated() {
        //
        //                    let maxRegion  = CLCircularRegion(center: CLLocationCoordinate2D(latitude: element.latitude ?? 0, longitude: element.longitude ?? 0),
        //                                                   radius: maxDistance,
        //                                                   identifier: "\(element.address ?? "")" + "\(Constants.Distance.longAway)")
        //                    let midRegion  =  CLCircularRegion(center: CLLocationCoordinate2D(latitude: element.latitude ?? 0, longitude: element.longitude ?? 0),
        //                                                       radius: midDistance,
        //                                                       identifier: "\(element.address ?? "")" + "\(Constants.Distance.medium)")
        //                    let nearRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: element.latitude ?? 0, longitude: element.longitude ?? 0),
        //                                                      radius: nearDistance,
        //                                                      identifier: "\(element.address ?? "")" + "\(Constants.Distance.near)")
        //
        //                    maxRegion.notifyOnEntry = true
        //                    maxRegion.notifyOnExit = false
        //
        //                    midRegion.notifyOnEntry = true
        //                    midRegion.notifyOnExit = false
        //
        //                    nearRegion.notifyOnEntry = true
        //                    nearRegion.notifyOnExit = false
        //
        //                    locationManager.startMonitoring(for: maxRegion)
        //                    locationManager.startMonitoring(for: midRegion)
        //                    locationManager.startMonitoring(for: nearRegion)
        //                }
        //            }
        //        }
        //    }
        //
        //    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //
        //        if let region = region as? CLCircularRegion {
        //
        //            guard let cameras = presenter?.cameraInfo() else { return }
        //            for (_, element) in cameras.enumerated() {
        //                hidePopUp()
        //                soundOncomingCamera()
        //                popUpAnimation()
        //
        //                if region.identifier.suffix(3) == "\(Constants.Distance.longAway)" {
        //                    popUpView?.update(entity: element, metersTo: Constants.Distance.longAway)
        //                } else if region.identifier.suffix(3) == "\(Constants.Distance.medium)" {
        //                    popUpView?.update(entity: element, metersTo: Constants.Distance.medium)
        //                } else if region.identifier.suffix(3) == "\(Constants.Distance.near)" {
        //                    popUpView?.update(entity: element, metersTo: Constants.Distance.near)
        //                }
        //            }
        //        }
        //    }
    }
}
