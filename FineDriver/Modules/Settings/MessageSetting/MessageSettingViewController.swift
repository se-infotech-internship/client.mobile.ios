//
//  MessageSettingViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 11.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol MessageSettingViewControllerProtocol: class {
    func reloadData()
}

final class MessageSettingViewController: UIViewController {
    
    private enum Constants {
        
        enum TableView {
            
            static let height: CGFloat = 56.0
        }
    }
    
    // MARK: - Private outlet
    @IBOutlet private weak var navigationView: NavigationView!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public property
    var presenter: MessageSettingPresenterProtocol?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

       setupNavigationView()
        setupTableView()
        presenter?.viewDidLoad()
        tableView.reloadData()
    }

    // MARK: - Private method
    private func setupNavigationView() {
        navigationView.update(title: "ШТРАФИ")
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        setupTableCell()
    }
    
    private func setupTableCell() {
        tableView.register(UINib(nibName: SwitchSettingCell.identifier, bundle: nil), forCellReuseIdentifier: SwitchSettingCell.identifier)
    }
}

// MARK: - Protocol methos
extension MessageSettingViewController: MessageSettingViewControllerProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Delegate methods
extension MessageSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.countRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = presenter?.model(index: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingCell.identifier, for: indexPath) as? SwitchSettingCell else { return UITableViewCell() }
        cell.update(entity: cellModel)
        return cell
    }
}
