//
//  AppCoordinator.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 18.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }

    func start()
}



struct AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    func start() {
        let authManager = AuthManager()
        let splashViewController = SplashViewController.initFromNib()
        let presenter = SplashPresenter(viewController: splashViewController
            , coordinator: self
            , authManager: authManager)
        splashViewController.presenter = presenter
        
        navigationController.viewControllers = [splashViewController]
    }
}
