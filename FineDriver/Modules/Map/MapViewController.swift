//
//  MapViewController.swift
//  FineDriver
//
//  Created by THXDBase on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

final class MapViewController: BaseViewController {
    
    private enum localConstants {
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
    }
    
    // MARK: - Private outlets
    @IBOutlet fileprivate weak var speedLabel: UILabel!
    @IBOutlet fileprivate weak var soundButton: UIButton!
    @IBOutlet fileprivate weak var mapView: GMSMapView!

    // MARK: - Public property
    var presenter: MapPresenterProtocol!
    
    // MARK: - Private property
    fileprivate var locationManager = CLLocationManager()
    fileprivate var currentLocation = CLLocationCoordinate2D()
    fileprivate var isCenterCamera = true
    fileprivate var isCheckButtonSound = false
    fileprivate var oldPolylineArr = [GMSPolyline]()
    fileprivate var popUpView: PopUpView?
    fileprivate var searchResultController: SearchResultsController!
    fileprivate var gmsFetcher: GMSAutocompleteFetcher!
    fileprivate var resultsArray = [String]()
    fileprivate var isFirstUpdate = true
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        fetchCameras()
        configureUI()
        configureLocationManager()
        setupMarkers()
    }

    
    // MARK: - Private methods
    
    fileprivate func addObservers() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(setupMarkers),
                         name: NSNotification.Name(Constants.setupMarkersNotification),
                         object: nil)
    }
    
    fileprivate func fetchCameras() {
        presenter.fetchCameras()
    }
    
    @objc fileprivate func setupMarkers() {
        presenter.setupMarkers(mapView: mapView, lastLocation: currentLocation)
    }
    
    fileprivate func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.activityType = .automotiveNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingHeading()
    }
    
    fileprivate func configureUI() {
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: localConstants.UkrainePosition.lat, longitude: localConstants.UkrainePosition.long))
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        mapView.animate(toZoom: localConstants.UkrainePosition.zoom)
        mapView.delegate = self
//        mapView.isMyLocationEnabled = true
        mapView.isTrafficEnabled = true
    
        searchResultController = AppCoordinator.shared.getSearchResults()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
    
    fileprivate func updateMarkerCameraWith(position: CLLocationCoordinate2D) {
        
        func update() {
            presenter.myLocationMarker.position = position
            if isCenterCamera {
                mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
                mapView.animate(toZoom: localConstants.Default.zoom)
            }
        }
        
        if !isFirstUpdate {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            update()
            CATransaction.commit()
        }else{
            update()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.isFirstUpdate = false
            }
        }
    }
    
    fileprivate func transformMyLocationMarker(angle: Double) {
        if angle >= 0 && angle < 360 {
            let angleInRadians: CGFloat = (CGFloat(angle) * .pi) / CGFloat(180) //From degrees to radians transformation
            presenter.myLocationMarker.iconView?.transform = CGAffineTransform.identity.rotated(by: angleInRadians)
        }else{
            presenter.myLocationMarker.iconView?.transform = CGAffineTransform.identity
        }
    }
    
    //MARK:- Popup
    
    fileprivate func setupPopUpView() {
        popUpView = PopUpView(frame:
                        CGRect(x: localConstants.PopUp.x,
                                y: localConstants.PopUp.y,
                                width: Double(mapView.frame.width),
                                height: Double(localConstants.PopUp.height)))
        
        view.addSubview(popUpView!)
    }
    
    fileprivate func popUpAnimation(isShow: Bool = true) {
        if popUpView == nil ||
            popUpView != nil &&
            !self.view.subviews.contains(popUpView!) {
            self.setupPopUpView()
        }
        
        UIView.animate(withDuration: localConstants.PopUp.animationTime) {
            if isShow {
                self.popUpView?.transform = CGAffineTransform(translationX:
                                                                localConstants.PopUp.translationX,
                                              y: self.view.safeAreaInsets.top +
                                                localConstants.PopUp.height)
            } else {
                self.popUpView?.transform = .identity
            }
        } completion: { [weak self] _ in
            if !isShow {
                DispatchQueue.main.asyncAfter(deadline: .now() + localConstants.PopUp.animationTime) {
                    self?.hidePopUp()
                }
            }
        }
    }
    
    fileprivate func hidePopUp() {
        popUpView?.removeFromSuperview()
    }
    
    // MARK: - Private actions
    
    @IBAction private func didTapSearchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapMenuButton(_ sender: Any) {
        presenter.routeToMenu()
    }
    
    @IBAction private func didTapCurrentLocationButton(_ sender: Any) {
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longitude = locationManager.location?.coordinate.longitude else {
            return
        }
        
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: latitude,
           longitude: longitude))
        mapView.animate(toZoom: localConstants.Default.zoom)
        isCenterCamera = true
    }
    
    @IBAction private func didTapSoundButton(_ sender: Any) {
        isCheckButtonSound = !isCheckButtonSound
        soundButton.isSelected = isCheckButtonSound
        if isCheckButtonSound {
            presenter?.stopSound()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - MapViewControllerProtocol

extension MapViewController: MapViewControllerProtocol {
    
    func drawPath(from polyStr: String) {
        DispatchQueue.main.async {
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
        }
    }
}

// MARK: - MapView Delegate methods
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        transformMyLocationMarker(angle: newHeading.trueHeading)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        popUpAnimation(isShow: false)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        popUpAnimation()
        
        guard let cameraInfo = marker.userData as? CameraEntity,
              let long = cameraInfo.longitude,
              let lat = cameraInfo.latitude else { return nil }
        
        let currentLoc = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let distance = currentLoc.distance(from: CLLocation(latitude: lat, longitude: long))
        popUpView?.update(entity: cameraInfo, metersTo: distance)
        
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            isCenterCamera = false
        }
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        presenter.fetchRoute(from: currentLocation, to: coordinate)
    }
}

// MARK: - LocationManager delegate method
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let lastLocation = locations.last,
              let speed = manager.location?.speed else { return }
                
        speedLabel.text = speed < 0 ? "0 км/г" : "\(Int(speed * 3.6)) км/г"
        currentLocation = lastLocation.coordinate
        updateMarkerCameraWith(position: lastLocation.coordinate)
        
        let cameras = presenter.cameraInfo()
        
        var allCameras: [CLLocation] = []
        
        for (_, element) in cameras.enumerated() {
            
            guard let latitude = element.latitude,
                  let longitude = element.longitude else {
                return
            }
            
            allCameras.append(CLLocation(latitude: latitude,
                                         longitude: longitude))
            
            let nearCamera = allCameras.min(by: { $0.distance(from: CLLocation(latitude: currentLocation.latitude,
                    longitude: currentLocation.longitude)) < $1.distance(from: CLLocation(latitude: currentLocation.latitude,
                                  longitude: currentLocation.longitude)) })
            
            guard let camera = nearCamera,
                  let address = element.address else { return }
            
            if camera.coordinate.latitude == element.latitude && camera.coordinate.longitude == element.longitude {
                #if DEBUG
                print("identifier = \(address)")
                #endif
                
                let currentLoc = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                let distance = currentLoc.distance(from: CLLocation(latitude: camera.coordinate.latitude, longitude: camera.coordinate.longitude))
                popUpView?.update(entity: element, metersTo: distance)
                
                monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: camera.coordinate.latitude, longitude: camera.coordinate.longitude), identifier: address)
            }
        }
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D,
                                 identifier: String ) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            let distance = presenter.fetchDistanceToCameraLocation()
            let maxDistance = CLLocationDistance(distance)
            let region = CLCircularRegion(center: center,
                                          radius: maxDistance,
                                          identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
//            for monitoredRegion in locationManager.monitoredRegions {
//                locationManager.stopMonitoring(for: monitoredRegion)
//            }
            
            locationManager.startMonitoring(for: region)
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("start update")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
            print("inside")
        } else if state == .outside {
            print("outside")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didEnterRegion region: CLRegion) {
        
        #if DEBUG
        print("didEnterRegion")
        #endif
        
        guard let region = region as? CLCircularRegion,
              let cameras = presenter?.cameraInfo() else { return }
        
        for (_, element) in cameras.enumerated() {
            if element.address == region.identifier,
               let address = element.address,
               let speed = element.speed {
                
                presenter.oncomingCamera(address: address,
                                         speedLimit: "\(speed)")
                
                let currentLoc = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                let distance = currentLoc.distance(from: CLLocation(latitude: region.center.latitude, longitude: region.center.longitude))
                
                popUpAnimation()
                popUpView?.update(entity: element, metersTo: distance)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion: CLRegion) {
        presenter?.stopSound()
        hidePopUp()
//        locationManager.stopMonitoring(for: didExitRegion)
    }
}

// MARK:- GMSAutocompleteFetcherDelegate

extension MapViewController: GMSAutocompleteFetcherDelegate {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions {
            if let prediction = prediction as GMSAutocompletePrediction? {
                resultsArray.append(prediction.attributedFullText.string)
            }
        }
        searchResultController.presenter.searchResults = resultsArray
    }
    
    func didFailAutocompleteWithError(_ error: Error) { } 

}

// MARK:- SearchResultsProtocol

extension MapViewController: SearchResultsProtocol {
    
    func locateWithLongitude(lon: Double, lat: Double) {
        
        let camera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: lon,
                                              zoom: 10)
        mapView.camera = camera
        presenter.fetchRoute(from: currentLocation,
                             to: CLLocationCoordinate2D(latitude: lat,
                                                        longitude: lon))
    }
}

// MARK:- UISearchBarDelegate

extension MapViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
}
