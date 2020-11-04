//
//  MessageSettingPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 11.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol MessageSettingViewControllerProtocol: class {
    func reloadData()
}

protocol MessageSettingPresenterProtocol: class {
    var itemCount: Int { get }

    func model(index: Int) -> SwitchItemEntity
    func viewDidLoad()
    func routePop()
}

final class MessageSettingPresenter {
    
    // MARK: - Protocol property
    weak var delegate: MessageSettingViewControllerProtocol?
    
    // MARK: - Private property
    private var entity = [SwitchItemEntity]()
    
    // MARK: - Public property
    var itemCount: Int {
        get{
            return entity.count
        }
    }
    
    // MARK: - LifeCycle
    init(delegate: MessageSettingViewControllerProtocol?) {
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func fetchMockSettingData() {
        entity = mockDataForMessageSettingVC()
    }
}

// MARK: - MessageSettingPresenterProtocol

extension MessageSettingPresenter: MessageSettingPresenterProtocol {
    
    func model(index: Int) -> SwitchItemEntity {
        return entity[index]
    }
    
    func viewDidLoad() {
        fetchMockSettingData()
    }
    
    func routePop() {
        AppCoordinator.shared.popVC()
    }
}
