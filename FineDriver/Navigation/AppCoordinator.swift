//
//  AppCoordinator.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 18.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController! { get set }
    
    func start()
    func routeToMap()
    func routeToMenu()
}

class AppCoordinator: CoordinatorProtocol {
    
    static let shared = AppCoordinator()
    
    private init() {}
    
    var navigationController: UINavigationController!
    
    func start() {
        let authManager = AuthManager()
        let splashViewController = SplashViewController()
        let presenter = SplashPresenter(viewController: splashViewController,
                                        authManager: authManager)
        splashViewController.presenter = presenter
        
        navigationController.viewControllers = [splashViewController]
    }
    
    func routeToMap() {
        let viewController = MapViewController()
        let presenter = MapPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.viewControllers = [viewController]
    }
    
    func routeToMenu() {
        let viewController = MenuViewController()
        let presenter = MenuPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.viewControllers = [viewController]
    }
    
    func routeToFinesList() {
        let viewController = FinesViewController()
        let presenter =  FinesPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.viewControllers = [viewController]
    }
}
