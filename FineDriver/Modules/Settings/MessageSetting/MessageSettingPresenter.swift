//
//  MessageSettingPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 11.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol MessageSettingPresenterProtocol: class {
    var view: MessageSettingViewControllerProtocol? { get set }
    func countRows() -> Int
    func model(index: Int) -> SwitchItemEntity
    func viewDidLoad()
    func routePop()
}

final class MessageSettingPresenter {
    
    // MARK: - Protocol property
    weak var view: MessageSettingViewControllerProtocol?
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    private var entity = [SwitchItemEntity]()
    
    // MARK: - LifeCycle
    init(view: MessageSettingViewControllerProtocol?) {
        self.view = view
    }
    
    // MARK: - Private methods
    private func fetchMockSettingData() {
        entity = mockDataForMessageSettingVC()
    }
}

// MARK: - Protocol methods
extension MessageSettingPresenter: MessageSettingPresenterProtocol {
    
    func countRows() -> Int {
        return entity.count
    }
    
    func model(index: Int) -> SwitchItemEntity {
        return entity[index]
    }
    
    func viewDidLoad() {
        fetchMockSettingData()
    }
    
    func routePop() {
        coordinator?.popVC()
    }
}
