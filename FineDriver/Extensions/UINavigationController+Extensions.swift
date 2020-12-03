//
//  UINavigationController+Extensions.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 03.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit
import Foundation

extension UINavigationController: UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

}
