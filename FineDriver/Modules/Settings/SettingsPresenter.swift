//
//  SettingsPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 09.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol SettingsPresenterProtocol: class {
    var view: SettingsViewControllerProtocol? { get set }
    func countRows() -> Int
    func model(index: Int) -> SettingItemEntity
    func viewDidLoad()
    func routeMessageSetting()
    func routePop()
}

final class SettingsPresenter {
    
    // MARK: - Protocol property
    weak var view: SettingsViewControllerProtocol?
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    private var settingItemsEntity = [SettingItemEntity]()
    
    // MARK: - LifeCycle
    init(view: SettingsViewControllerProtocol?) {
        self.view = view
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
    
    func countRows() -> Int {
        return settingItemsEntity.count
    }
    
    func viewDidLoad() {
        fetchMockSettingData()
    }
    
    func routePop() {
        coordinator?.popVC()
    }
    
    func routeMessageSetting() {
        coordinator?.routeToMessageSetting()
    }
}
