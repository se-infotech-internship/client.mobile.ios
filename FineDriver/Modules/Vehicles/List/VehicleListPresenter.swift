//
//  VehicleListPresenter.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 03.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol VehicleListProtocol: class {
    func reloadData()
}

protocol VehicleListPresenterProtocol {
    var itemCount: Int { get }

}

final class VehicleListPresenter: NSObject, VehicleListPresenterProtocol {
    
    var itemCount: Int = 3
    
    weak var delegate: VehicleListProtocol?
    
    init(delegate: VehicleListProtocol) {
        self.delegate = delegate
    }

}
