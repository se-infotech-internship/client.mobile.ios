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

protocol MapPresenterProtocol: class {
    var view: MapViewControllerProtocol? { get set}
    var camerasEntity: [CameraEntity] { get set }
    func viewDidLoad()
    func markersLocation() -> ([CLLocationCoordinate2D])
    func routeToMenu()
    func cameraInfo() -> [CameraEntity]
    func model(index: Int) -> CameraEntity
    func playSound(forResource: String, withExtension: String)
    func stopSound()
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D)
}

class MapPresenter {
    
    // MARK: - Protocol property
    weak var view: MapViewControllerProtocol?
    var camerasEntity: [CameraEntity] = []
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    private let localService = ServiceLocalFile()
    private var player: AVAudioPlayer?
    
    // MARK: - LifeCycle
    init(view: MapViewControllerProtocol?) {
        self.view = view
    }
    
    // MARK: - Private method
    private func fetchCameras() {
        
        localService.fetchLocationList(jsonData: localService.readLocalFile() ?? Data(), success: { [weak self] (cameras) in
            
            guard let self = self else { return }
            
            for camera in cameras {
                
                self.camerasEntity.append(CameraEntity(address: camera.address,
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
}

// MARK: - Protocol methods
extension MapPresenter: MapPresenterProtocol {
    
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
                        
                        guard let self = self, let view = self.view else { return }
                        
                        view.drawPath(from: polyString)
                    }
                    
                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
    }
    
    
    func markersLocation() -> ([CLLocationCoordinate2D]) {
        return camerasEntity.map { CLLocationCoordinate2D(latitude: $0.latitude ?? 0, longitude: $0.longitude ?? 0) }
    }
    
    func viewDidLoad() {
        fetchCameras()
    }
    
    func routeToMenu() {
        coordinator?.routeToMenu()
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
}
