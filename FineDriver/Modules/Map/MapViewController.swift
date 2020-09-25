//
//  MapViewController.swift
//  FineDriver
//
//  Created by THXDBase on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol MapViewControllerProtocol: class {
    
}

class MapViewController: UIViewController {
    
    // MARK: - Public property
    var presenter: MapPresenterProtocol?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //TODO: - implement. now it is a stub
    @IBAction private func onMenuHandler(_ sender: Any) {
        presenter?.menuHandler()
    }
}

// MARK: - Protocol methods
extension MapViewController: MapViewControllerProtocol {
    
}
