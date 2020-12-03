//
//  VehicleHeaderView.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 03.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class VehicleHeaderView: UITableViewHeaderFooterView {

    @IBOutlet fileprivate weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.white
    }
}
