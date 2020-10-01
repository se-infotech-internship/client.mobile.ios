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
    var pinsEntity: [PinEntity] { get set }
    func viewDidLoad()
    func markersLocation() -> ([CLLocationCoordinate2D])
    func routeToMenu()
    func pinInfo() -> [PinEntity]
}

class MapPresenter {
    
    // MARK: - Protocol property
    weak var view: MapViewControllerProtocol?
    var pinsEntity: [PinEntity] = []
    
    // MARK: - Private property
    private let coordinator = AppCoordinator.shared
    
    // MARK: - LifeCycle
    init(view: MapViewControllerProtocol?) {
        self.view = view
    }
}

// MARK: - Protocol methods
extension MapPresenter: MapPresenterProtocol {
    
    func markersLocation() -> ([CLLocationCoordinate2D]) {
        return pinsEntity.map { CLLocationCoordinate2D(latitude: $0.lat ?? 0, longitude: $0.long ?? 0) }
    }
    
    func viewDidLoad() {
        pinsEntity = mockDataForMapVC()
    }
    
    func routeToMenu() {
        coordinator.routeToMenu()
    }
    
    func pinInfo() -> [PinEntity] {
        return pinsEntity
    }
}
