//
//  SelectFineSettingPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 19.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol SelectFineSettingViewControllerProtocol: class {
    func reloadData()
}

protocol SelectFineSettingPresenterProtocol: class {
    var itemCount: Int { get }

    func model(index: Int) -> SelectFineEntity
    func viewDidLoad()
    func routePop()
    func selectFineCheckmark(indexItem: Int)
}

final class SelectFineSettingPresenter {
    
    // MARK: - Protocol property
    weak var delegate: SelectFineSettingViewControllerProtocol?
    
    // MARK: - Private property
    private var entity = [SelectFineEntity]()
    
    // MARK: - Public property
    var itemCount: Int {
        get{
            entity.count
        }
    }
    
    init(delegate: SelectFineSettingViewControllerProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func fetchMockFineSelectSettingData() {
        entity = mockSelectFineSetting()
    }
}

// MARK: - SelectFineSettingPresenterProtocol

extension SelectFineSettingPresenter: SelectFineSettingPresenterProtocol {
    
    func model(index: Int) -> SelectFineEntity {
        return entity[index]
    }
    
    func viewDidLoad() {
        fetchMockFineSelectSettingData()
    }
    
    func routePop() {
        AppCoordinator.shared.popVC()
    }
    
    func selectFineCheckmark(indexItem: Int) {
        
        for (index, _) in entity.enumerated() {
            if index == indexItem {
                model(index: index).isSelect = true
            } else {
                model(index: index).isSelect = false
            }
        }
        delegate?.reloadData()
    }
}
