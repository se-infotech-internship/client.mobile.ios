//
//  SplashPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation


protocol SplashPresenterProtocol {
    var viewController: SplashViewControllerProtocol? { get set }
    func auth()
}

final class SplashPresenter {
    
    // MARK: - Protocol property
    weak var viewController: SplashViewControllerProtocol?
    
    // MARK: - Private property
    private let coordinator = AppCoordinator.shared
    private var authManager: AuthManagerProtocol!
    
    // MARK: - LifeCycle
    init(viewController: SplashViewControllerProtocol?,
         authManager: AuthManagerProtocol) {
        
        self.viewController = viewController
        self.authManager = authManager
    }
}

// MARK: - Protocol methods
extension SplashPresenter: SplashPresenterProtocol {
    
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
