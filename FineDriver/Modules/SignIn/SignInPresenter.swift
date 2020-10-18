//
//  SignInPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 23.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol SignInPresenterProtocol: class {
    var view: SignInViewControllerProtocol? { get set }
    func routeToMap()
    func saveToUserDefaults(login: String, firstName: String, familyName: String, email: String, tokenId: String)
}

final class SignInPresenter {
    
    // MARK: - Protocol property
    weak var view: SignInViewControllerProtocol?
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    private let defaults = UserDefaults.standard
    
    // MARK: - LifeCycle
    init(view: SignInViewControllerProtocol?) {
        self.view = view
    }
}

// MARK: - protocol methods
extension SignInPresenter: SignInPresenterProtocol {
    
    func saveToUserDefaults(login: String, firstName: String, familyName: String, email: String, tokenId: String) {
        defaults.register(defaults: [.user: login,
                                     .firstName: firstName,
                                     .familyName: familyName,
                                     .email: email,
                                     .tokenId: tokenId])
    }
    
    func routeToMap() {
        coordinator?.routeToMap()
    }
}
