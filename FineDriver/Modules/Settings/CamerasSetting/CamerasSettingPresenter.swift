//
//  CamerasSettingPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 18.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol CamerasSettingViewProtocol: class {
    func reloadData()
}

protocol CamerasSettingPresenterProtocol: class {
    var itemCount: Int { get }

    func model(index: Int) -> SettingItemEntity
    func viewDidLoad()
    func routePop()
}

final class CamerasSettingPresenter {
    
    // MARK: - Protocol property
    weak var delegate: CamerasSettingViewProtocol?
    
    // MARK: - Private property
    private var entity = [SettingItemEntity]()
    
    // MARK: - Public property
    var itemCount: Int {
        get{
            entity.count
        }
    }
    
    init(delegate: CamerasSettingViewProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func fetchMockSettingData() {
        entity = mockCameraSetting()
    }
}

// MARK: - CamerasSettingPresenterProtocol

extension CamerasSettingPresenter: CamerasSettingPresenterProtocol {
    
    func model(index: Int) -> SettingItemEntity {
        return entity[index]
    }
    
    func viewDidLoad() {
        fetchMockSettingData()
    }
    
    func routePop() {
        AppCoordinator.shared.popVC()
    }
}
