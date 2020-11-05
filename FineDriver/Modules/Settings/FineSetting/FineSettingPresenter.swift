//
//  FineSettingPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 19.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol FineSettingViewControllerProtocol: class {
    func reloadData()
}

protocol FineSettingPresenterProtocol: class {
    var itemCount: Int { get }

    func model(index: Int) -> SettingItemEntity
    func viewDidLoad()
    func routePop()
    func routeSelectFineSetting()
}


final class FineSettingPresenter {
    
    // MARK: - Protocol property
    weak var delegate: FineSettingViewControllerProtocol?
    
    // MARK: - Private property
    private var entity = [SettingItemEntity]()
    
    // MARK: - Public property
    var itemCount: Int {
        get{
            entity.count
        }
    }
    
    init(delegate: FineSettingViewControllerProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func fetchMockFineSettingData() {
        entity = mockFineSetting()
    }
}


// MARK: - FineSettingPresenterProtocol

extension FineSettingPresenter: FineSettingPresenterProtocol {
    
    func model(index: Int) -> SettingItemEntity {
        return entity[index]
    }
    
    func viewDidLoad() {
        fetchMockFineSettingData()
    }
    
    func routePop() {
        AppCoordinator.shared.popVC()
    }
    
    func routeSelectFineSetting() {
        AppCoordinator.shared.routeToSelectFineSetting()
    }
}
