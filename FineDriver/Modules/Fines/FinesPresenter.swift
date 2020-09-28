//
//  FinesPresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 28.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol FinesPresenterProtocol: class {
    var view: FinesViewControllerProtocol? { get set }
    func countRows() -> Int
    func model(index: Int) -> FineEntity
    func viewDidLoad()
    func fines() -> [FineEntity]
}

final class FinesPresenter {
    
    // MARK: - Protocol property
    weak var view: FinesViewControllerProtocol?
    
    // MARK: - Private property
    private var fineEntities = [FineEntity]()
    
    // MARK: - LifeCycle
    init(view: FinesViewControllerProtocol?) {
        self.view = view
    }
    
    // MARK: - Private method
    private func fetchFines() {
        fineEntities = mockDataForFinesVC()
    }
}

// MARK: - Protocol methods
extension FinesPresenter: FinesPresenterProtocol {
    func countRows() -> Int {
        return fineEntities.count
    }
    
    func model(index: Int) -> FineEntity {
        return fineEntities[index]
    }
    
    func viewDidLoad() {
        fetchFines()
    }
    
    func fines() -> [FineEntity] {
        return fineEntities
    }
}
