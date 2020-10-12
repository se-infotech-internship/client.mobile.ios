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
    func update(entity: CameraEntity, metersTo camera: Double) {
        
        speedLimitLabel.text = "\(entity.speed ?? 0) км/г"
        addressLabel.text = entity.address
        metersToCameraLabel.text = "\(Int(camera)) м"
    }
}
