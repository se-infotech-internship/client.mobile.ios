//
//  VehicleListCell.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 03.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

class VehicleListCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var imgView: UIImageView!
    @IBOutlet fileprivate weak var plateLabel: UILabel!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var fineQuantityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
