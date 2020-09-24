//
//  AppDelegate.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 18.09.2020.
//

import UIKit
// Can`t compile a project on XCode 11.6 with @main attribute
//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var coordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        coordinator = AppCoordinator.shared
        coordinator?.navigationController = navigationController
        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        //
        
        return true
    }
}

