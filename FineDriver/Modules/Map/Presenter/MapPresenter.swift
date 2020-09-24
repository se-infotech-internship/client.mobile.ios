//
//  MapPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol MapPresenterProtocol {
    func menuHandler()
}

class MapPresenter: MapPresenterProtocol {
    private let coordinator = AppCoordinator.shared
    
    
    func menuHandler() {
        coordinator.routeToMenu()
    }
}
