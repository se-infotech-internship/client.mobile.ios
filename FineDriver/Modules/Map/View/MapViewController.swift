//
//  MapViewController.swift
//  FineDriver
//
//  Created by THXDBase on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    var presenter: MapPresenterProtocol!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //TODO: - implement. now it is a stub
    @IBAction func onMenuHandler(_ sender: Any) {
        presenter.menuHandler()
    }
}
