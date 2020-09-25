//
//  SplashPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation


protocol SplashPresenterProtocol {
    func auth()
}

final class SplashPresenter: SplashPresenterProtocol {
    var viewController: SplashViewControllerProtocol!
    private let coordinator = AppCoordinator.shared
    var authManager: AuthManagerProtocol!
    
    init(viewController: SplashViewControllerProtocol,
         authManager: AuthManagerProtocol) {
        
        self.viewController = viewController
        self.authManager = authManager
    }
    
    func auth() {
        authManager.auth { [weak self] (result) in
            switch result {
            case .success(let authObj):
                self?.coordinator.routeToMap()
            case .failure(let err):
                break
            }
        }
    }
}
