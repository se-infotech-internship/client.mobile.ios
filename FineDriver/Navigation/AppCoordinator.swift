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
    
    func popVC()
    func start()
    func routeToMap()
    func routeToMenu()
    func routeToAuth()
    func routeToSetting()
    func routeToMessageSetting()
}

class AppCoordinator: CoordinatorProtocol {
    
    static let shared = AppCoordinator()
    
    private init() {}
    
    var navigationController: UINavigationController!
    
    func popVC() {
        navigationController.popViewController(animated: true)
    }
    
    func start() {
        let authManager = AuthManager()
        let viewController = SplashViewController()
        let presenter = SplashPresenter(viewController: viewController,
                                        authManager: authManager)
        viewController.presenter = presenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToAuth() {
        let viewController = SignInViewController()
        let presenter = SignInPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToMap() {
        let viewController = MapViewController()
        let presenter = MapPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToMenu() {
        let viewController = MenuViewController()
        let presenter = MenuPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToFinesList() {
        let viewController = FinesViewController()
        let presenter =  FinesPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToSetting() {
        let viewController = SettingsViewController()
        let presenter = SettingsPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToMessageSetting() {
        let viewController = MessageSettingViewController()
        let presenter = MessageSettingPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
