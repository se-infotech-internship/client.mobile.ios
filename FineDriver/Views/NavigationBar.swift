//
//  NavigationBar.swift
//  FineDriver
//
//  Created by Вячеслав on 17.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

@objc protocol NavigationBarDelegate: class {
    @objc optional func leftAction()
    @objc optional func rightAction()
}

class NavigationBar: NibView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    
    weak var delegate: NavigationBarDelegate?
    
    func update(title: String) {
        titleLabel.text = title
    }
    
    @IBAction private func didTapPopVC(_ sender: Any) {
        delegate?.leftAction?()
    }
}
