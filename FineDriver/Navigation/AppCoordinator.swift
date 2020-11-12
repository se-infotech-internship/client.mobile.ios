//
//  AppCoordinator.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 18.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController? { get set }
    
    func popVC()
    func start()
    func routeToMap()
    func routeToMenu()
    func routeToAuth()
    func routeToSetting()
    func routeToMessageSetting()
    func routeToProfile()
    func routeToCamerasSetting()
    func routeToFineSetting()
    func routeToSelectFineSetting()
}

final class AppCoordinator: CoordinatorProtocol {
    
    static let shared = AppCoordinator()
    private init() {}
    
    var navigationController: UINavigationController?
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func start() {
        let viewController = SplashViewController()
        let presenter = SplashPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:- Navigate
    
    func routeToAuth() {
        KeychainStorage.accessToken = nil
        
        let viewController = SignInViewController()
        let presenter = SignInPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func routeToMap() {
        let viewController = MapViewController()
        let presenter = MapPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func routeToMenu() {
        let viewController = MenuViewController()
        let presenter = MenuPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToFinesList() {
        let viewController = FinesViewController()
        let presenter =  FinesPresenter(delegate: viewController)
        viewController.presenter = presenter
    
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToSetting() {
        let viewController = SettingsViewController()
        let presenter = SettingsPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToMessageSetting() {
        let viewController = MessageSettingViewController()
        let presenter = MessageSettingPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToProfile() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToCamerasSetting() {
        let viewController = CamerasSettingViewController()
        let presenter = CamerasSettingPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToFineSetting() {
        let viewController = FineSettingViewController()
        let presenter = FineSettingPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToSelectFineSetting() {
        let viewController = SelectFineSettingViewController()
        let presenter = SelectFineSettingPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:- Get
    
    func getSearchResults() -> SearchResultsController {
        let viewController = SearchResultsController()
        let presenter = SearchResultsPresenter(delegate: viewController)
        viewController.presenter = presenter
        
        return viewController
    }
}
