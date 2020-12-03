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
    var itemCount: Int { get }
    
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
    
    var itemCount: Int {
        get{
            menuItemsEntity.count
        }
    }
    
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
    
    func model(index: Int) -> MenuItemEntity {
        return menuItemsEntity[index]
    }
    
    func viewDidLoad() {
        fetchMockMenuData()
    }
    
    func routeMap() {
        AppCoordinator.shared.navigationController?.popViewController(animated: true)
    }
    
    func routeFines() {
        AppCoordinator.shared.routeToVehicleList()
    }
    
    func routeAuth() {
        AppCoordinator.shared.routeToAuth()
    }
    
    func routeSetting() {
        AppCoordinator.shared.routeToSetting()
    }
    
    func routeProfile() {
        AppCoordinator.shared.routeToProfile()
    }
    
    func fetchImage(imageView: UIImageView) {
        
        var avatarURL: URL?
        avatarURL = UserDefaults.standard[.avatarURL]
        guard let url = avatarURL else { return }
        
        imageView.kf.setImage(with: url)
    }
}
