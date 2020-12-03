//
//  NewVehiclePresenter.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 02.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol NewVehicleViewProtocol: class {

}

protocol NewVehiclePresenterProtocol: class {
    var itemCount: Int { get }

    func model(index: Int) -> FineEntity
    func viewDidLoad()
    func fines() -> [FineEntity]
}

final class NewVehiclePresenter {
    
    // MARK: - Protocol property
    weak var delegate: NewVehicleViewProtocol?
    
    // MARK: - Private property
    private var fineEntities = [FineEntity]()
    
    // MARK: - Public property
    var itemCount: Int {
        get{
            return fineEntities.count
        }
    }
    
    // MARK: - LifeCycle
    init(delegate: NewVehicleViewProtocol?) {
        self.delegate = delegate
    }
    
    // MARK: - Private method
    private func fetchFines() {
        fineEntities = mockDataForFinesVC()
    }
}

// MARK: - FinesPresenterProtocol

extension NewVehiclePresenter: NewVehiclePresenterProtocol {
    
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
