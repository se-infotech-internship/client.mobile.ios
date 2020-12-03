//
//  MapPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import GoogleMaps
import AVFoundation
import GooglePlaces

protocol MapViewControllerProtocol: class {
    func drawPath(from polyStr: String)
}

protocol MapPresenterProtocol: class {
    var camerasEntity: [CameraEntity] { get set }
    var myLocationMarker: GMSMarker! { get }
    
    func muteSound(muted: Bool)
    func oncomingCamera(address: String,
                        speedLimit: String)
    func fetchCameras()
    func setupMarkers(mapView: GMSMapView, lastLocation: CLLocationCoordinate2D?)
    func markersLocation() -> ([CLLocationCoordinate2D])
    func routeToMenu()
    func cameraInfo() -> [CameraEntity]
    func model(index: Int) -> CameraEntity
    func playSound(forResource: String, withExtension: String)
    func stopSound()
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D)
    func fetchDistanceToCameraLocation() -> Int
    func sendNotification(address: String,
                          warning: String,
                          speedLimit: String)
}

final class MapPresenter {
    
    // MARK: - Protocol property
    weak var delegate: MapViewControllerProtocol?
    var camerasEntity: [CameraEntity] = []
    var myLocationMarker: GMSMarker!
    
    // MARK: - Private property
    fileprivate let localService = ServiceLocalFile()
    fileprivate var player: AVAudioPlayer?
    fileprivate var mutedSound: Bool = false

    
    // MARK: - LifeCycle
    init(delegate: MapViewControllerProtocol?) {
        self.delegate = delegate
    }
    
}

// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
    
    func fetchCameras() {
        localService.fetchLocationList(jsonData: localService.readLocalFile() ?? Data(), success: { [weak self] (cameras) in
            for camera in cameras {
                self?.camerasEntity
                    .append(CameraEntity(address: camera.address,
                                       latitude: camera.latitude,
                                       longitude: camera.longitude,
                                       direction: camera.direction,
                                       speed: camera.speed,
                                       state: camera.state))
            }
        }, fail: { (error) in
            debugPrint("fetchLocationList - \(error)")
        })
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=walking&key=\(Constants.googleMapKey)") else { return }
        
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            
            if data == nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String: Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        let preRoutes = json["routes"] as! NSArray
                        let routes = preRoutes[0] as! NSDictionary
                        let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                        let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                        self?.delegate?.drawPath(from: polyString)
                    }
                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
    }
    
    func markersLocation() -> ([CLLocationCoordinate2D]) {
        return camerasEntity.compactMap {
            if let latitude = $0.latitude,
               let longitude = $0.longitude {
                return CLLocationCoordinate2D(latitude: latitude,
                                              longitude: longitude)
            }else{
                return nil
            }
        }
    }
    
    func setupMarkers(mapView: GMSMapView,
                      lastLocation: CLLocationCoordinate2D? = nil) {
        mapView.clear()
        
        let coordinates = markersLocation()
        let camera = cameraInfo()
        var cameraData = CameraEntity()
        var circle = GMSCircle()
        
        myLocationMarker = GMSMarker()
        myLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        myLocationMarker.iconView = UIImageView(image: UIImage(named: "ic_my_location"))
        myLocationMarker.map = mapView
        if let lastLocation = lastLocation {
            myLocationMarker.position = lastLocation
        }
        
        for (index, element) in coordinates.enumerated() {
            
            let marker = GMSMarker()
            marker.position.latitude = element.latitude
            marker.position.longitude = element.longitude
            
            if element.latitude == camera[index].latitude &&
                element.longitude == camera[index].longitude {
                
                cameraData.address = camera[index].address
                cameraData.direction = camera[index].direction
                cameraData.speed = camera[index].speed
                cameraData.state = camera[index].state
                cameraData.latitude = camera[index].latitude
                cameraData.longitude = camera[index].longitude
                
                if camera[index].state == "on" {
                    marker.icon = UIImage(named: "Marker")
                } else {
                    marker.icon = UIImage(named: "Camera_off")
                }
                
                circle = GMSCircle(position:
                    CLLocationCoordinate2D(latitude: element.latitude,
                    longitude: element.longitude),
                    radius:CLLocationDistance(fetchDistanceToCameraLocation()))
                circle.fillColor = UIColor(red: 0.992,
                                           green: 0.818,
                                           blue: 0.818,
                                           alpha: 0.3)
                circle.strokeColor = .clear
            }
            
            marker.userData = cameraData
            marker.map = mapView
            circle.map = mapView
        }
    }
    
    func routeToMenu() {
        AppCoordinator.shared.routeToMenu()
    }
    
    func cameraInfo() -> [CameraEntity] {
        return camerasEntity
    }
    
    func model(index: Int) -> CameraEntity {
        return camerasEntity[index]
    }
    
    func fetchDistanceToCameraLocation() -> Int {
        let defaults = UserDefaults.standard
        return defaults[.distanceToCamera]
    }
    
    //MARK:- Sound
    func oncomingCamera(address: String,
                        speedLimit: String) {
        sendNotification(address: address,
                         speedLimit: speedLimit)
        playSound()
    }
    
    func playSound(forResource: String = "02869", withExtension: String = "mp3") {
        stopSound()
        
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,
                                                        options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.volume = mutedSound ? 0.0 : 1.0
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        guard let player = player else { return }
        player.stop()
    }
    
    func muteSound(muted: Bool) {
        guard let player = player else { return }
        mutedSound = muted
        player.volume = mutedSound ? 0.0 : 1.0
    }
    
    //MARK:- Notification
    
    func sendNotification(address: String,
                          warning: String = "Неподалiк камера!",
                          speedLimit: String) {
    
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(warning) \(fetchDistanceToCameraLocation()) м"
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
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
}
