//
//  SettingsPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 09.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol SettingsViewControllerProtocol: class {
    func reloadData()
}

protocol SettingsPresenterProtocol: class {
    var itemCount: Int { get }

    func model(index: Int) -> SettingItemEntity
    func viewDidLoad()
    func routeMessageSetting()
    func routePop()
    func routeCamerasSetting()
    func routeToFineSetting()
}

final class SettingsPresenter {
    
    // MARK: - Protocol property
    weak var delegate: SettingsViewControllerProtocol?
    
    // MARK: - Private property
    private var settingItemsEntity = [SettingItemEntity]()
    
    // MARK: - Public property
    var itemCount: Int {
        get{
            return settingItemsEntity.count
        }
    }
    
    // MARK: - LifeCycle
    init(delegate: SettingsViewControllerProtocol?) {
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func fetchMockSettingData() {
        settingItemsEntity = mockDataForSettingVC()
    }
}

// MARK: - Protocol methods
extension SettingsPresenter: SettingsPresenterProtocol {
    
    func model(index: Int) -> SettingItemEntity {
        return settingItemsEntity[index]
    }
    
    func viewDidLoad() {
        fetchMockSettingData()
    }
    
    func routePop() {
        AppCoordinator.shared.popVC()
    }
    
    func routeMessageSetting() {
        AppCoordinator.shared.routeToMessageSetting()
    }
    
    func routeCamerasSetting() {
        AppCoordinator.shared.routeToCamerasSetting()
    }
    
    func routeToFineSetting() {
        AppCoordinator.shared.routeToFineSetting()
    }
}
