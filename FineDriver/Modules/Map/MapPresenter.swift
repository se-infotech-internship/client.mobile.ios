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
}

class MapPresenter {
    
    // MARK: - Protocol property
    weak var view: MapViewControllerProtocol?
    var camerasEntity: [CameraEntity] = []
    
    // MARK: - Private property
    private let coordinator = AppCoordinator.shared
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
    
    func markersLocation() -> ([CLLocationCoordinate2D]) {
        return camerasEntity.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }
    
    func viewDidLoad() {
        fetchCameras()
    }
    
    func routeToMenu() {
        coordinator.routeToMenu()
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
