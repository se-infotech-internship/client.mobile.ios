//
//  CamerasSettingPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 18.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol CamerasSettingPresenterProtocol: class {
    var view: CamerasSettingViewProtocol? { get set }
    func countRows() -> Int
    func model(index: Int) -> SettingItemEntity
    func viewDidLoad()
    func routePop()
}

final class CamerasSettingPresenter {
    
    // MARK: - Protocol property
    weak var view: CamerasSettingViewProtocol?
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    private var entity = [SettingItemEntity]()
    
    init(view: CamerasSettingViewProtocol) {
        self.view = view
    }
    
    // MARK: - Private methods
    private func fetchMockSettingData() {
        entity = mockCameraSetting()
    }
}

// MARK: - Protocol methods
extension CamerasSettingPresenter: CamerasSettingPresenterProtocol {
    
    func countRows() -> Int {
        return entity.count
    }
    
    func model(index: Int) -> SettingItemEntity {
        return entity[index]
    }
    
    func viewDidLoad() {
        fetchMockSettingData()
    }
    
    func routePop() {
        coordinator?.popVC()
    }
}
