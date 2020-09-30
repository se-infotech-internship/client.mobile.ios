//
//  FinesViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 28.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol FinesViewControllerProtocol: class {
    func reloadData()
}

final class FinesViewController: UIViewController {
    
    // MARK:- Private outlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public properties
    var presenter: FinesPresenterProtocol?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupTableCell()
        setupTableView()
    }

    // MARK: - Private methods
    private func setupTableCell() {
        tableView.register(UINib(nibName: FineCell.identifier, bundle: nil), forCellReuseIdentifier: FineCell.identifier)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Protocol methods
extension FinesViewController: FinesViewControllerProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - FineCellDelegate method
extension FinesViewController: FineCellDelegate {
    func changeSize(_ cell: FineCell, fineButtonTappedFor fine: Bool) {
        guard let isLowSize = cell.isLowSize else { return }
        cell.changeSizeData(isLowSize)
    }
}

// MARK: - TableView methods
extension FinesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.countRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FineCell.identifier) as? FineCell, let presenter = presenter else { return UITableViewCell() }
        cell.update(entity: presenter.model(index: indexPath.row))
        cell.delegate = self
        return cell
    }
    
}
