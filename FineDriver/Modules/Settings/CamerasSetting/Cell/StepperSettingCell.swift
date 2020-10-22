//
//  StepperSettingCell.swift
//  FineDriver
//
//  Created by Вячеслав on 18.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit



class StepperSettingCell: UITableViewCell {
    
    // MARK: - Private outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    // MARK: - Private property
    private var entity: StepperEntity?
    private var defaults = UserDefaults.standard
    
    static let identifier = "StepperSettingCell"

    func update(entity: StepperEntity) {
        self.entity = entity
        guard let entity = self.entity else { return }
        titleLabel.text = "\(entity.title)"
        
        self.entity?.distance = defaults[.distanceToCamera]
        distanceLabel.text = "\(entity.distance) м"
    }
    
    // MARK: - Private action
    @IBAction private func didTapPlusMeters(_ sender: Any) {
        
        guard let entity = entity else { return }
        if entity.distance < 700 {
            entity.distance += 100
            distanceLabel.text = "\(entity.distance) м"
            
            defaults[.distanceToCamera] = entity.distance
            
        }
        self.entity?.distance = entity.distance
    }
    
    @IBAction private func didTapMinusMeters(_ sender: Any) {
        guard let entity = entity else { return }
        if entity.distance > 100 {
            entity.distance -= 100
            distanceLabel.text = "\(entity.distance) м"
            defaults[.distanceToCamera] = entity.distance
        }
        self.entity?.distance = entity.distance
    }
    
}
