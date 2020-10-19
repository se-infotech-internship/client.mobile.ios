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
    
    // MARK: - Public property
    var presenter: SplashPresenterProtocol?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.checkToken()
    }
}

// MARK: - Protocol methods
extension SplashViewController: SplashViewControllerProtocol {
    
}
