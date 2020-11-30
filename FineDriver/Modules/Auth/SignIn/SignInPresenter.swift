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
    func routeToMap()
    func saveToUserDefaults(login: String,
                            firstName: String,
                            familyName: String,
                            email: String,
                            tokenId: String,
                            avatarURL: URL?)
    func resetToken()
}

final class SignInPresenter {
    
    // MARK: - Protocol property
    weak var delegate: SignInViewControllerProtocol?
    
    // MARK: - Private property
    fileprivate let defaults = UserDefaults.standard
    
    // MARK: - LifeCycle
    init(delegate: SignInViewControllerProtocol?) {
        self.delegate = delegate
    }
}

// MARK: - protocol methods
extension SignInPresenter: SignInPresenterProtocol {
    
    func saveToUserDefaults(login: String,
                            firstName: String,
                            familyName: String,
                            email: String,
                            tokenId: String,
                            avatarURL: URL? = nil) {
        
        defaults[.user] = login
        defaults[.firstName] = firstName
        defaults[.familyName] = familyName
        defaults[.email] = email
        defaults[.avatarURL] = avatarURL
        KeychainStorage.accessToken = tokenId
    }
    
    func routeToMap() {
        AppCoordinator.shared.routeToMap()
    }
    
    func resetToken() {
        KeychainStorage.accessToken = nil
        defaults[.distanceToCamera] = Constants.Camera.maxDistance
    }
}
