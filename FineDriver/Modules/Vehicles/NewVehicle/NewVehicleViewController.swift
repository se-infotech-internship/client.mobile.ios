//
//  NewVehicleViewController.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 02.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class NewVehicleViewController: BaseViewController {
    
    // MARK:- Private outlet
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    
    // MARK: - Public properties
    var presenter: NewVehiclePresenterProtocol!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupNavigationBar()
    }


    // MARK: - Private methods
    
    private func setupNavigationBar() {
        customNavigationBar.delegate = self
        customNavigationBar.update(title: "РЕЄСТРАЦІЯ ТЗ")
    }
    
    // MARK: - Private action
    
    @IBAction fileprivate func loginAction(_ sender: Any) {
        AppCoordinator.shared.routeToSignIn()
    }
}

// MARK: - NewVehicleViewProtocol

extension NewVehicleViewController: NewVehicleViewProtocol {
    
    
}
