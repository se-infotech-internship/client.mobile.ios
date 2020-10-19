//
//  SplashPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import LocalAuthentication


protocol SplashPresenterProtocol {
    var viewController: SplashViewControllerProtocol? { get set }
    func auth()
    func checkToken()
}

final class SplashPresenter {
    
    // MARK: - Protocol property
    weak var viewController: SplashViewControllerProtocol?
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    private var authManager: AuthManagerProtocol!
    
    // MARK: - LifeCycle
    init(viewController: SplashViewControllerProtocol?,
         authManager: AuthManagerProtocol) {
        
        self.viewController = viewController
        self.authManager = authManager
    }
    
    private func routeAuth() {
        coordinator?.routeToAuth()
    }
    
    private func routeMap() {
        coordinator?.routeToMap()
    }
    
    private func faceTouchAuth() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Потрібно Вас ідентифікувати☺️"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.routeMap()
                    } else {
                        print("biometric error")
                    }
                }
            }
        }
    }
}

// MARK: - Protocol methods
extension SplashPresenter: SplashPresenterProtocol {
    
    func auth() { // TODO: - doesn't using in this version
        authManager.auth { [weak self] (result) in
            switch result {
            case .success(let authObj):
                self?.coordinator?.routeToAuth()
            case .failure(let err):
                break
            }
        }
    }
    
    func checkToken() {
        var token: String?
        let defaults = UserDefaults.standard
        token = defaults[.tokenId]
        
        if token != "" && token != nil  {
            faceTouchAuth()
        } else {
            routeAuth()
        }
    }
}
