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



class AppCoordinator: CoordinatorProtocol {
    // не понял зачем нужен синглтон - мы же будем передавать ссылку на координатор в презентеры
    // также поменял СТРАКТ на КЛАСС 
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let authManager = AuthManager()
        let splashViewController = SplashViewController()
        let presenter = SplashPresenter(viewController: splashViewController
            , coordinator: self
            , authManager: authManager)
        splashViewController.presenter = presenter
        
        navigationController.viewControllers = [splashViewController]
    }
}
