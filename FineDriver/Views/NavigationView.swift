//
//  NavigationView.swift
//  FineDriver
//
//  Created by Вячеслав on 10.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol NavigationViewProtocol: class {
    func routePopVC()
}

class NavigationView: NibView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    private let coordinator = AppCoordinator.shared
    
    func update(title: String) {
        titleLabel.text = title
    }
    
    @IBAction private func didTapPopButton(_ sender: Any) {
        routePopVC()
    }
}

extension NavigationView: NavigationViewProtocol {
    
    func routePopVC() {
        coordinator.popVC()
    }
}
