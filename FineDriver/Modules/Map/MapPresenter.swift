//
//  MapPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol MapPresenterProtocol: class {
    var view: MapViewControllerProtocol? { get set}
    func menuHandler()
}

class MapPresenter {
    
    // MARK: - Protocol property
    weak var view: MapViewControllerProtocol?
    
    // MARK: - Private property
    private let coordinator = AppCoordinator.shared
    
    // MARK: - LifeCycle
    init(view: MapViewControllerProtocol?) {
        self.view = view
    }
}

// MARK: - Protocol methods
extension MapPresenter: MapPresenterProtocol {
    
    func menuHandler() {
        coordinator.routeToMenu()
    }
}
