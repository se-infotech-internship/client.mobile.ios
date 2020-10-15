//
//  UINavigationController.swift
//  FineDriver
//
//  Created by Вячеслав on 13.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController:UINavigationControllerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: self.interactivePopGestureRecognizer)) {
            if viewControllers.count > 1 {
                interactivePopGestureRecognizer?.isEnabled = true
            } else {
                interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }
}
