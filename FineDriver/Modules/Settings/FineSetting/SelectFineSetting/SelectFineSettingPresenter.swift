//
//  SelectFineSettingPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 19.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol SelectFineSettingPresenterProtocol: class {
    var view: SelectFineSettingViewControllerProtocol? { get set }
    func countRows() -> Int
    func model(index: Int) -> SelectFineEntity
    func viewDidLoad()
    func routePop()
    func selectFineCheckmark(indexItem: Int)
}

final class SelectFineSettingPresenter {
    
    // MARK: - Protocol property
    weak var view: SelectFineSettingViewControllerProtocol?
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    private var entity = [SelectFineEntity]()
    
    init(view: SelectFineSettingViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Private methods
    private func fetchMockFineSelectSettingData() {
        entity = mockSelectFineSetting()
    }
}

// MARK: - Protocol methods
extension SelectFineSettingPresenter: SelectFineSettingPresenterProtocol {
    func countRows() -> Int {
        return entity.count
    }
    
    func model(index: Int) -> SelectFineEntity {
        return entity[index]
    }
    
    func viewDidLoad() {
        fetchMockFineSelectSettingData()
    }
    
    func routePop() {
        coordinator?.popVC()
    }
    
    func selectFineCheckmark(indexItem: Int) {
        
        for (index, _) in entity.enumerated() {
            if index == indexItem {
                model(index: index).isSelect = true
            } else {
                model(index: index).isSelect = false
            }
        }
        view?.reloadData()
    }
}
