//
//  BaseSettingCell.swift
//  FineDriver
//
//  Created by Вячеслав on 11.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

class BaseSettingCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    static let identifier = "BaseSettingCell"
    
    func update(entity: SettingItemEntity) {
        titleLabel.text = entity.title
    }
}
