//
//  EnterViewController.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 30.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class EnterViewController: BaseViewController {

    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Private action
    @IBAction private func withoutSigningUpAction(_ sender: Any) {
        AppCoordinator.shared.routeToMap()
    }
    
    @IBAction private func signingUpAction(_ sender: Any) {
        AppCoordinator.shared.routeToSignIn(signingup: true)
    }
    
    @IBAction private func signInAction(_ sender: Any) {
        AppCoordinator.shared.routeToSignIn()
    }
}
