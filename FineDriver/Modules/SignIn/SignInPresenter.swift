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
}

final class SignInPresenter {
    
    // MARK: - Protocol property
    weak var view: SignInViewControllerProtocol?
    
    init(view: SignInViewControllerProtocol?) {
        self.view = view
    }
}

// MARK: - protocol methods
extension SignInPresenter: SignInPresenterProtocol {

}
