//
//  SettingFineCell.swift
//  FineDriver
//
//  Created by Вячеслав on 19.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

class SettingFineCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkImageView: UIImageView!
    
    // MARK: - Private property
    private var entity: SelectFineEntity?
    
    static let identifier = "SettingFineCell"
    
    func update(entity: SelectFineEntity) {
        self.entity = entity
        guard let entity = self.entity else { return }
        titleLabel.text = entity.title
        
        if self.entity?.isSelect == true {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
    }
    
//    func setCheckmark(entity: SelectFineEntity) {
//        guard let model = self.entity else { return }
//        
//        if entity.title == model.title {
//            entity.isSelect = true
//            
//            if entity.isSelect {
//                checkImageView.isHidden = false
//            } else {
//                checkImageView.isHidden = true
//            }
//        } else {
//            entity.isSelect = false
//        }
//    }
}
