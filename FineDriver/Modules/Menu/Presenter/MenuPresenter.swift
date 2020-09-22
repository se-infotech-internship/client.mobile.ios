//
//  MenuPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import UIKit

protocol MenuPresenterProtocol: class {
    
    var view: MenuViewControllerProtocol? { get set }
    func countRows() -> Int
    func model(index: Int) -> MenuItemEntity
    func viewDidLoad()
}

final class MenuPresenter {
    
    // MARK: - Public property
    weak var view: MenuViewControllerProtocol?
    
    // MARK: - Private property
    private var menuItemsEntity = [MenuItemEntity]()
    
    // MARK: - Private method
    private func fetchMockMenuData() { // TODO: - work with mockData
        menuItemsEntity = mockDataForMenuVC()
    }
}

// MARK: - Protocol methods
extension MenuPresenter: MenuPresenterProtocol {
    
    func countRows() -> Int {
        return  menuItemsEntity.count
    }
    
    func model(index: Int) -> MenuItemEntity {
        return menuItemsEntity[index]
    }
    
    func viewDidLoad() {
        fetchMockMenuData()
    }
}
