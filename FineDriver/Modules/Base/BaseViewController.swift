//
//  BaseViewController.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 30.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
    }
    
    #if DEBUG
    deinit { print("🟢 \(#function) \(self)") }
    #endif

}
