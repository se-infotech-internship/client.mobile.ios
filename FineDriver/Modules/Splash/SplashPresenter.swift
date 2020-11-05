//
//  SplashPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import LocalAuthentication


protocol SplashViewProtocol: class {

}

protocol SplashPresenterProtocol {
    var delegate: SplashViewProtocol? { get set }
    
    func auth()
    func checkToken()
}

final class SplashPresenter {
    
    // MARK: - Protocol property
    weak var delegate: SplashViewProtocol?
    
    // MARK: - Private property
    private var authManager: AuthManagerProtocol!
    
    // MARK: - LifeCycle
    init(delegate: SplashViewProtocol?) {
        self.delegate = delegate
    }
    
    private func routeAuth() {
        AppCoordinator.shared.routeToAuth()
    }
    
    private func routeMap() {
        AppCoordinator.shared.routeToMap()
    }
    
    private func faceTouchAuth() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Потрібно Вас ідентифікувати"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.routeMap()
                    } else {
                        self?.routeAuth()
                        print("biometric error")
                        print(authenticationError?.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - SplashPresenterProtocol

extension SplashPresenter: SplashPresenterProtocol {
    
    func auth() { // TODO: - doesn't using in this version
//        authManager.auth { [weak self] (result) in
//            switch result {
//            case .success(let authObj):
//                AppCoordinator.shared.routeToAuth()
//            case .failure(let err):
//                break
//            }
//        }
    }
    
    func checkToken() {
        if KeychainStorage.accessToken != nil {
            faceTouchAuth()
        } else {
            routeAuth()
        }
    }
}
