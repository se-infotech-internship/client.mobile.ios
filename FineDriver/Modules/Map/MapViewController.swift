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
import UserNotifications


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
    }
    
    // MARK: - Private outlets
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var soundButton: UIButton!
    @IBOutlet private weak var mapView: GMSMapView!
    
    private var popUpView: PopUpView?
    private var searchResultController: SearchResultsController!
    private var gmsFetcher: GMSAutocompleteFetcher!
    
    // MARK: - Public property
    var presenter: MapPresenterProtocol?
    var resultsArray = [String]()
    let userNotificationCenter = UNUserNotificationCenter.current()
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // MARK: - Private property
    private var locationManager = CLLocationManager()
    private var currentLocation = CLLocationCoordinate2D()
    private var isCenterCamera = true
    private var isUpdateLocation = true
    private var isSoundMusic = false
    private var isCheckButtonSound = false
    private var oldPolylineArr = [GMSPolyline]()
    private var isInRadiusCameraAlready = true
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setCurrentLocation()
        setupMapView()
        setupMarkers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
    }
    
    deinit {
        print("deinit MapViewController")
        endBackgroundTask()
        
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        
        requestNotificationAuthorization()
        self.userNotificationCenter.delegate = self
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        registerBackgroundTask()
    }
    
    private func setCurrentLocation() {
        
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: Constants.UkrainePosition.lat, longitude: Constants.UkrainePosition.long))
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        mapView.animate(toZoom: Constants.UkrainePosition.zoom)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.activityType = .automotiveNavigation
        locationManager.requestAlwaysAuthorization()
    }
    
    private func setupMapView() {
        mapView.isTrafficEnabled = true
    }
    
    private func setupMarkers() {
        
        guard let presenter = presenter else { return }
        let coordinates = presenter.markersLocation()
        let cameraInfo = presenter.cameraInfo()
        var cameraData = CameraEntity()
        var circle = GMSCircle()
        
        for (index, element) in coordinates.enumerated() {
            
            let marker = GMSMarker()
            marker.position.latitude = element.latitude
            marker.position.longitude = element.longitude
            
            if element.latitude == cameraInfo[index].latitude && element.longitude == cameraInfo[index].longitude {
                cameraData.address = cameraInfo[index].address
                cameraData.direction = cameraInfo[index].direction
                cameraData.speed = cameraInfo[index].speed
                cameraData.state = cameraInfo[index].state
                cameraData.latitude = cameraInfo[index].latitude
                cameraData.longitude = cameraInfo[index].longitude
                
                if cameraInfo[index].state == "on" {
                    marker.icon = UIImage(named: "Marker")
                } else {
                    marker.icon = UIImage(named: "Camera_off")
                }
                
                circle = GMSCircle(position: CLLocationCoordinate2D(latitude: element.latitude,
                                                                    longitude: element.longitude),
                                   radius: CLLocationDistance(presenter.fetchDistanceToCameraLocation()))
                circle.fillColor = UIColor(red: 0.992, green: 0.818, blue: 0.818, alpha: 0.3)
                circle.strokeColor = .clear
            }
            
            marker.userData = cameraData
            marker.map = mapView
            circle.map = mapView
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
                                                              y: self.view.safeAreaInsets.top + Constants.PopUp.height)
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
        presenter?.stopSound()
        presenter?.playSound(forResource: forResource, withExtension: withExtension)
    }
    
    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    private func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    
    // MARK: - Private action
    @IBAction private func didTapSearchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
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
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        popUpAnimation(isShow: false)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        hidePopUp()
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
        
        guard let cameras = presenter?.cameraInfo() else { return }
        
        var allCameras: [CLLocation] = []
        
        for (_, element) in cameras.enumerated() {
            
            allCameras.append(CLLocation(latitude: element.latitude ?? 0, longitude: element.longitude ?? 0))
            
            let nearCamera = allCameras.min(by: { $0.distance(from: CLLocation(latitude: currentLocation.latitude,
                                                                                    longitude: currentLocation.longitude)) < $1.distance(from: CLLocation(latitude: currentLocation.latitude,
                                                                                                                                                          longitude: currentLocation.longitude)) })
            guard let camera = nearCamera else { return }
            
            if camera.coordinate.latitude == element.latitude && camera.coordinate.longitude == element.longitude {
                
                guard let address = element.address else { return }
                print("identifier = \(address)")
                monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: camera.coordinate.latitude, longitude: camera.coordinate.longitude), identifier: address)
            }
        }
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            guard let distance = presenter?.fetchDistanceToCameraLocation() else { return }
            let maxDistance = CLLocationDistance(distance)
            
            let region = CLCircularRegion(center: center,
                                          radius: maxDistance,
                                          identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
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
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print("method didEnterRegion work!!!")
        
        if let region = region as? CLCircularRegion {
            
            let identifier = region.identifier
            guard let cameras = presenter?.cameraInfo() else { return }
            
            for (_, element) in cameras.enumerated() {
                
                if element.address == identifier {
                    
                    sendNotification(address: element.address ?? "", speedLimit: "\(element.speed ?? 0)")
                    hidePopUp()
                    presenter?.playSound(forResource: "02869", withExtension: "mp3")
                    popUpAnimation()
                    
                    let currentLoc = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                    let distance = currentLoc.distance(from: CLLocation(latitude: region.center.latitude, longitude: region.center.longitude))
                    popUpView?.update(entity: element, metersTo: distance)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion: CLRegion) {
        presenter?.stopSound()
        hidePopUp()
        locationManager.stopMonitoring(for: didExitRegion)
    }
}

// MARK: Search delegates
extension MapViewController: UISearchBarDelegate, LocateOnTheMap, GMSAutocompleteFetcherDelegate {
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
        self.mapView.camera = camera
        self.presenter?.fetchRoute(from: self.currentLocation, to: CLLocationCoordinate2D(latitude: lat, longitude: lon))
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction? {
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
    }
    
    func didFailAutocompleteWithError(_ error: Error) { } 
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
}

// MARK: - UserNotification
extension MapViewController: UNUserNotificationCenterDelegate {
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(address: String, warning: String = "Неподалiк камера!", speedLimit: String) {
        
        guard let presenter = presenter else { return }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(warning) \(presenter.fetchDistanceToCameraLocation()) м"
        notificationContent.subtitle = address
        notificationContent.body = "Дозволена швидкість \(speedLimit) км/г"
        notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName("02869.mp3"))
        
        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
