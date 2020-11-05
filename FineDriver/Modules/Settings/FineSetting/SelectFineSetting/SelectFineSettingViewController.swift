//
//  SelectFineSettingViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 19.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class SelectFineSettingViewController: UIViewController {
    
    private enum Constants {
        enum TableView {
            static let height: CGFloat = 56.0
        }
    }
    
    // MARK: - Private outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    
    // MARK: - Public property
    var presenter: SelectFineSettingPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()
        presenter?.viewDidLoad()
    }

    // MARK: - Private method
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        setupTableCell()
    }
    
    private func setupTableCell() {
        tableView.register(UINib(nibName: SettingFineCell.identifier, bundle: nil), forCellReuseIdentifier: SettingFineCell.identifier)
    }
    
    private func setupNavigationBar() {
        customNavigationBar.update(title: "ШТРАФИ")
        customNavigationBar.delegate = self
    }
}

// MARK: - Delegate methods
extension SelectFineSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingFineCell.identifier, for: indexPath) as? SettingFineCell else { return UITableViewCell() }
        let cellModel = presenter.model(index: indexPath.row)
        cell.update(entity: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectFineCheckmark(indexItem: indexPath.row)
    }
}

// MARK: - SelectFineSettingViewControllerProtocol

extension SelectFineSettingViewController: SelectFineSettingViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - NavigationBarDelegate method
extension SelectFineSettingViewController: NavigationBarDelegate {
    func leftAction() {
        presenter?.routePop()
    }
}
