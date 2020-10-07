//
//  MapPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import GoogleMaps

protocol MapPresenterProtocol: class {
    var view: MapViewControllerProtocol? { get set}
    var camerasEntity: [CameraEntity] { get set }
    func viewDidLoad()
    func markersLocation() -> ([CLLocationCoordinate2D])
    func routeToMenu()
    func cameraInfo() -> [CameraEntity]
}

class MapPresenter {
    
    // MARK: - Protocol property
    weak var view: MapViewControllerProtocol?
    var camerasEntity: [CameraEntity] = []
    
    // MARK: - Private property
    private let coordinator = AppCoordinator.shared
    private let localService = ServiceLocalFile()
    
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
}
