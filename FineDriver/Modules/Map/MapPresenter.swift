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
    
    func fetchCameras()
    func markersLocation() -> ([CLLocationCoordinate2D])
    func routeToMenu()
    func cameraInfo() -> [CameraEntity]
    func model(index: Int) -> CameraEntity
    func playSound(forResource: String, withExtension: String)
    func stopSound()
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D)
    func fetchDistanceToCameraLocation() -> Int
}

final class MapPresenter {
    
    // MARK: - Protocol property
    weak var delegate: MapViewControllerProtocol?
    var camerasEntity: [CameraEntity] = []
    
    // MARK: - Private property
    private let localService = ServiceLocalFile()
    private var player: AVAudioPlayer?
    
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
    
    func routeToMenu() {
        AppCoordinator.shared.routeToMenu()
    }
    
    func cameraInfo() -> [CameraEntity] {
        return camerasEntity
    }
    
    func model(index: Int) -> CameraEntity {
        return camerasEntity[index]
    }
    
    func playSound(forResource: String, withExtension: String = "mp3") {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        guard let player = player else { return }
        player.stop()
    }
    
    func fetchDistanceToCameraLocation() -> Int {
        let defaults = UserDefaults.standard
        return defaults[.distanceToCamera]
    }
}
