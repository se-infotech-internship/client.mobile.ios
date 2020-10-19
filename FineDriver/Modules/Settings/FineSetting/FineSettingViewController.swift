//
//  FineSettingViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 19.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol FineSettingViewControllerProtocol: class {
    func reloadData()
}

final class FineSettingViewController: UIViewController {
    
    private enum Constants {
        
        enum TableView {
            
            static let height: CGFloat = 56.0
        }
    }

    // MARK: - Private outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    
    // MARK: - Public property
    var presenter: FineSettingPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()
        presenter?.viewDidLoad()
        reloadData()
    }
    
    // MARK: - Private method
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        setupTableCell()
    }
    
    private func setupTableCell() {
        tableView.register(UINib(nibName: BaseSettingCell.identifier, bundle: nil), forCellReuseIdentifier: BaseSettingCell.identifier)
        tableView.register(UINib(nibName: SwitchSettingCell.identifier, bundle: nil), forCellReuseIdentifier: SwitchSettingCell.identifier)
    }
    
    private func setupNavigationBar() {
        customNavigationBar.update(title: "ШТРАФИ")
        customNavigationBar.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - Protocol methos
extension FineSettingViewController: FineSettingViewControllerProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Delegate methods
extension FineSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.countRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        
        case 0:
            guard let model = presenter?.model(index: indexPath.row) as? SettingItemEntity,
                  let switchCell = tableView.dequeueReusableCell(withIdentifier: BaseSettingCell.identifier, for: indexPath) as? BaseSettingCell else { return UITableViewCell() }
            switchCell.update(entity: model)
            return switchCell
        case 1:
            guard let model = presenter?.model(index: indexPath.row) as? SwitchItemEntity,
                  let stepperCell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingCell.identifier, for: indexPath) as? SwitchSettingCell else { return UITableViewCell() }
            stepperCell.update(entity: model)
            return stepperCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            presenter?.routeSelectFineSetting()
        default:
            break
        }
    }
}

// MARK: - NavigationBarDelegate method
extension FineSettingViewController: NavigationBarDelegate {
    
    func leftAction() {
        presenter?.routePop()
    }
}

// MARK: - Pop gesture delegate method
extension FineSettingViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
