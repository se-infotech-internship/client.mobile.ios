//
//  MenuPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol MenuViewControllerProtocol: class {
    func reloadData()
}

protocol MenuPresenterProtocol: class {
    var delegate: MenuViewControllerProtocol? { get set }
    
    func countRows() -> Int
    func model(index: Int) -> MenuItemEntity
    func viewDidLoad()
    func routeMap()
    func routeFines()
    func routeAuth()
    func routeSetting()
    func routeProfile()
    func fetchImage(imageView: UIImageView)
}

final class MenuPresenter {
    
    // MARK: - Public property
    weak var delegate: MenuViewControllerProtocol?
    
    // MARK: - Private property
    private var menuItemsEntity = [MenuItemEntity]()
    private weak var coordinator = AppCoordinator.shared
    
    // MARK: - LifeCycle
    init(delegate: MenuViewControllerProtocol?) {
        self.delegate = delegate
    }
    
    // MARK: - Private method
    private func fetchMockMenuData() { // TODO: - work with mockData
        menuItemsEntity = mockDataForMenuVC()
    }
}

// MARK: - MenuPresenterProtocol

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
    
    func routeMap() {
        coordinator?.navigationController?.popViewController(animated: true)
//        coordinator?.routeToMap()
    }
    
    func routeFines() {
        coordinator?.routeToFinesList()
    }
    
    func routeAuth() {
        coordinator?.routeToAuth()
    }
    
    func routeSetting() {
        coordinator?.routeToSetting()
    }
    
    func routeProfile() {
        coordinator?.routeToProfile()
    }
    
    func fetchImage(imageView: UIImageView) {
        
        var avatarURL: URL?
        avatarURL = UserDefaults.standard[.avatarURL]
        guard let url = avatarURL else { return }
        
        imageView.kf.setImage(with: url)
    }
}
