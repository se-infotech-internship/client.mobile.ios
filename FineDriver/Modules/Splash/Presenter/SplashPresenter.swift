//
//  SplashPresenter.swift
//  FineDriver
//
//  Created by THXDBase on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation


protocol SplashPresenterProtocol {

}

final class SplashPresenter: SplashPresenterProtocol {
    var viewController: SplashViewControllerProtocol!
    var coordinator: CoordinatorProtocol!
    var authManager: AuthManagerProtocol!
    
    init(viewController: SplashViewControllerProtocol
        , coordinator: CoordinatorProtocol
        , authManager: AuthManagerProtocol) {
        
        self.viewController = viewController
        self.coordinator = coordinator
        self.authManager = authManager
    }
}
