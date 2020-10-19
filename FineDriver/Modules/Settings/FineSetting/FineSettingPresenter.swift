//
//  FineSettingPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 19.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol FineSettingPresenterProtocol: class {
    var view: FineSettingViewControllerProtocol? { get set }
    func countRows() -> Int
    func model(index: Int) -> SettingItemEntity
    func viewDidLoad()
    func routePop()
    func routeSelectFineSetting()
}


final class FineSettingPresenter {
    
    // MARK: - Protocol property
    weak var view: FineSettingViewControllerProtocol?
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    private var entity = [SettingItemEntity]()
    
    init(view: FineSettingViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Private methods
    private func fetchMockFineSettingData() {
        entity = mockFineSetting()
    }
}


// MARK: - Protocol methods
extension FineSettingPresenter: FineSettingPresenterProtocol {
    
    func countRows() -> Int {
        return entity.count
    }
    
    func model(index: Int) -> SettingItemEntity {
        return entity[index]
    }
    
    func viewDidLoad() {
        fetchMockFineSettingData()
    }
    
    func routePop() {
        coordinator?.popVC()
    }
    
    func routeSelectFineSetting() {
        coordinator?.routeToSelectFineSetting()
    }
}
