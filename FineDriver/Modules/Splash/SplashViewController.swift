//
//  SplashViewController.swift
//  FineDriver
//
//  Created by THXDBase on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    fileprivate var statusBarStyle = UIStatusBarStyle.lightContent {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }
    
    //MARK: - Public property
    var presenter: SplashPresenterProtocol?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.checkToken()
    }
}

//MARK: - SplashViewProtocol

extension SplashViewController: SplashViewProtocol {
    
}
