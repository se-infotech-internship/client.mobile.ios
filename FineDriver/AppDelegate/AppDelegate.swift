//
//  AppDelegate.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 18.09.2020.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        coordinator = AppCoordinator.shared
        coordinator?.navigationController = navigationController
        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // MARK: - Google Auth
        GIDSignIn.sharedInstance().clientID = "683824327490-qsfdggpdqrbk4odheepi0a9t8nr5t73u.apps.googleusercontent.com" // TODO: - Change key (it's mock data!)
        GIDSignIn.sharedInstance()?.delegate = self
        
        // MARK: - Facebook Auth
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        
        return true
    }
}

// MARK: - Google Auth Delegate methods
extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) { }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
}

// MARK: - Facebook Auth method
extension AppDelegate {

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}


