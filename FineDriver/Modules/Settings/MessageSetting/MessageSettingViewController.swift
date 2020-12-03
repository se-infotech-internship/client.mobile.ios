//
//  MessageSettingViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 11.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class MessageSettingViewController: BaseViewController {
    
    private enum Constants {
        enum TableView {
            static let height: CGFloat = 56.0
        }
    }
    
    // MARK: - Private outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    
    // MARK: - Public property
    var presenter: MessageSettingPresenterProtocol!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()
        presenter.viewDidLoad()
    }

    // MARK: - Private method
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        setupTableCell()
    }
    
    private func setupTableCell() {
        tableView.register(UINib(nibName: SwitchSettingCell.identifier, bundle: nil), forCellReuseIdentifier: SwitchSettingCell.identifier)
    }
    
    private func setupNavigationBar() {
        customNavigationBar.delegate = self
        customNavigationBar.update(title: "ПОВIДОМЛЕННЯ")
    }
}

// MARK: - MessageSettingViewControllerProtocol

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
        return presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingCell.identifier, for: indexPath) as? SwitchSettingCell else { return UITableViewCell() }
        let cellModel = presenter.model(index: indexPath.row)
        cell.update(entity: cellModel)
        return cell
    }
}
