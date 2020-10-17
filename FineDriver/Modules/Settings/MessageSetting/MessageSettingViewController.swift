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
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    
    // MARK: - Public property
    var presenter: MessageSettingPresenterProtocol?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()
        presenter?.viewDidLoad()
        tableView.reloadData()
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
        customNavigationBar.update(title: "ПОВIДОМЛЕННЯ")
        customNavigationBar.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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

// MARK: - NavigationBarDelegate method
extension MessageSettingViewController: NavigationBarDelegate {
    
    func leftAction() {
        presenter?.routePop()
    }
}

// MARK: - Pop gesture delegate method
extension MessageSettingViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
