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
        
        print("SplashViewController = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToAuth() {
        let viewController = SignInViewController()
        let presenter = SignInPresenter(view: viewController)
        viewController.presenter = presenter
        
        print("routeToAuth = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func routeToMap() {
        let viewController = MapViewController()
        let presenter = MapPresenter(view: viewController)
        viewController.presenter = presenter
        
        print("routeToMap = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func routeToMenu() {
        let viewController = MenuViewController()
        let presenter = MenuPresenter(view: viewController)
        viewController.presenter = presenter
        
        print("routeToMenu = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToFinesList() {
        let viewController = FinesViewController()
        let presenter =  FinesPresenter(view: viewController)
        viewController.presenter = presenter
    
        print("routeToFinesList = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToSetting() {
        let viewController = SettingsViewController()
        let presenter = SettingsPresenter(view: viewController)
        viewController.presenter = presenter
        
        print("routeToSetting = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToMessageSetting() {
        let viewController = MessageSettingViewController()
        let presenter = MessageSettingPresenter(view: viewController)
        viewController.presenter = presenter
        
        print("routeToMessageSetting = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToProfile() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(view: viewController)
        viewController.presenter = presenter
        
        print("routeToProfile = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToCamerasSetting() {
        let viewController = CamerasSettingViewController()
        let presenter = CamerasSettingPresenter(view: viewController)
        viewController.presenter = presenter
        
        print("routeToProfile = \(navigationController?.viewControllers ?? [UIViewController()])")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToFineSetting() {
        let viewController = FineSettingViewController()
        let presenter = FineSettingPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToSelectFineSetting() {
        let viewController = SelectFineSettingViewController()
        let presenter = SelectFineSettingPresenter(view: viewController)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
