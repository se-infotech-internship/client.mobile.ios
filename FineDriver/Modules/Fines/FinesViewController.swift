//
//  FinesViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 28.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class FinesViewController: BaseViewController {
    
    // MARK:- Private outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    
    // MARK: - Public properties
    var presenter: FinesPresenterProtocol!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupNavigationBar()
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
    
    private func setupNavigationBar() {
        customNavigationBar.delegate = self
        customNavigationBar.update(title: "ШТРАФИ")
    }
    
    // MARK: - Private action
    
    @IBAction fileprivate func registerAction(_ sender: Any) {
        AppCoordinator.shared.routeToSignIn(signingup: true)
    }
    
    @IBAction fileprivate func addAction(_ sender: Any) {
        AppCoordinator.shared.routeToNewNewVehicle()
    }
}

// MARK: - FinesViewControllerProtocol

extension FinesViewController: FinesViewControllerProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - FineCellDelegate method
extension FinesViewController: FineCellDelegate {
    func changeSize(_ cell: FineCell, fineButtonTappedFor fine: Bool) {
        guard let isLowSize = cell.isHiddingContent else { return }
        cell.changeSizeData(isLowSize)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - TableView methods
extension FinesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FineCell.identifier) as? FineCell else { return UITableViewCell() }
        cell.update(entity: presenter.model(index: indexPath.row))
        cell.delegate = self
        return cell
    }
}
