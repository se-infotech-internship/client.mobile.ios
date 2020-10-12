//
//  SettingsViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 09.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol SettingsViewControllerProtocol: class {
    func reloadData()
}

final class SettingsViewController: UIViewController {
    
    private enum Constants {
        
        enum TableView {
            
            static let height: CGFloat = 56.0
        }
    }
    
    // MARK: - Private outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navigationView: NavigationView!
    
    // MARK: - Public property
    var presenter: SettingsPresenterProtocol?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationView()
        setupTableView()
        presenter?.viewDidLoad()
        reloadData()
    }
    
    // MARK: - Private func
    private func setupNavigationView() {
        navigationView.update(title: "НАЛАШТУВАННЯ")
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        setupTableCell()
    }
    
    private func setupTableCell() {
        tableView.register(UINib(nibName: BaseSettingCell.identifier, bundle: nil), forCellReuseIdentifier: BaseSettingCell.identifier)
    }
}

// MARK: - Protocol methods
extension SettingsViewController: SettingsViewControllerProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Delegate methods
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.countRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = presenter?.model(index: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: BaseSettingCell.identifier, for: indexPath) as? BaseSettingCell else { return UITableViewCell() }
        cell.update(entity: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0: presenter?.routeMessageSetting()
        case 1: break
        case 2: break
        case 3: break
        case 4: break
        default: break
        }
    }
}
