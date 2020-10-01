//
//  PopUpView.swift
//  FineDriver
//
//  Created by Вячеслав on 30.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

class PopUpView: NibView {

    // MARK: - Private outlets
    @IBOutlet private weak var speedLimitLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var metersToCameraLabel: UILabel!
    
    // MARK: - Public property
    func update(entity: PinEntity) {
        speedLimitLabel.text = entity.limitation
        addressLabel.text = entity.adress
    }
}
