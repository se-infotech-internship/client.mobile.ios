//
//  BaseNavigationController.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 02.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let newTabBarHeight: CGFloat = 80
//        var newFrame = navigationBar.frame
//        newFrame.size.height = newTabBarHeight
////        newFrame.origin.y = 20
//
//        navigationBar.frame = newFrame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let newTabBarHeight: CGFloat = 80
//        var newFrame = navigationBar.frame
//        newFrame.size.height = newTabBarHeight
//        newFrame.origin.y += 20
//
//        navigationBar.frame = newFrame
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        let newTabBarHeight: CGFloat = 80
//        var newFrame = navigationBar.frame
//        newFrame.size.height = newTabBarHeight
//
//        navigationBar.frame = newFrame
    }

}

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 51)
    }
}

class TTNavigationBar: UINavigationBar {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 55)
    }

}
