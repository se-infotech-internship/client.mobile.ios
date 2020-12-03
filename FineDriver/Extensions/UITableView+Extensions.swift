//
//  UITableView+Extensions.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 03.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

extension UITableView{
    
    func register(cellType: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: cellType.self), bundle: nil), forCellReuseIdentifier: String(describing: cellType.self))
    }
    
}
