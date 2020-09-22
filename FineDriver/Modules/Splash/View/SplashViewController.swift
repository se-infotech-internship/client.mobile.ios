//
//  SplashViewController.swift
//  FineDriver
//
//  Created by THXDBase on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol SplashViewControllerProtocol: class {
    
}

class SplashViewController: UIViewController {
    var presenter: SplashPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension SplashViewController: SplashViewControllerProtocol {
    
}
