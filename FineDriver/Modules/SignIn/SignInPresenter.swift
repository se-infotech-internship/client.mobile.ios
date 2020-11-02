//
//  SignInPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 23.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol SignInViewControllerProtocol: class {
    
}

protocol SignInPresenterProtocol: class {
    var view: SignInViewControllerProtocol? { get set }
    
    func routeToMap()
    func saveToUserDefaults(login: String, firstName: String, familyName: String, email: String, tokenId: String, avatarURL: URL)
    func resetToken()
    func defaultDistaceLocationToCamera()
}

final class SignInPresenter {
    
    // MARK: - Protocol property
    weak var view: SignInViewControllerProtocol?
    
    // MARK: - Private property
    fileprivate let defaults = UserDefaults.standard
    
    // MARK: - LifeCycle
    init(view: SignInViewControllerProtocol?) {
        self.view = view
    }
}

// MARK: - protocol methods
extension SignInPresenter: SignInPresenterProtocol {
    
    func saveToUserDefaults(login: String, firstName: String, familyName: String, email: String, tokenId: String, avatarURL: URL) {
        defaults[.user] = login
        defaults[.firstName] = firstName
        defaults[.familyName] = familyName
        defaults[.email] = email
        defaults[.tokenId] = tokenId
        defaults[.avatarURL] = avatarURL
    }
    
    func routeToMap() {
        AppCoordinator.shared.routeToMap()
    }
    
    func resetToken() {
        defaults[.tokenId] = ""
        KeychainStorage.accessToken = nil
    }
    
    func defaultDistaceLocationToCamera() {
        defaults[.distanceToCamera] = 700
    }
}
