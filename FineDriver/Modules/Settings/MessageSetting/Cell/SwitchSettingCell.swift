//
//  SwitchSettingCell.swift
//  FineDriver
//
//  Created by Вячеслав on 11.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

class SwitchSettingCell: UITableViewCell {
    
    // MARK: - Private outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var agreeSwitch: UISwitch!
    
    // MARK: - Private property
    private var entity: SwitchItemEntity?
    
    static let identifier = "SwitchSettingCell"
    
    
    
    // MARK: - Public property
    func update(entity: SwitchItemEntity) {
        
        self.entity = entity
        guard let entity = self.entity else { return }
        titleLabel.text = entity.title
    }
    
    // MARK: - Private action
    @IBAction private func didTapSwitch(_ sender: Any) {
        
        guard let entity = entity else { return }
        if agreeSwitch.isOn {
            entity.isOn = true
        } else {
            entity.isOn = false
        }
    }
}
