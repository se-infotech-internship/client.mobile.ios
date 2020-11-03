//
//  MenuViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class MenuViewController: BaseViewController {
    
    private enum Layout {
        enum TableView {
            static let height: CGFloat = 58.0
        }
    }

    // MARK: - Private outlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public properties
    var presenter: MenuPresenterProtocol?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    // MARK: - Private methods
    private func setupView() {
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        
        presenter?.fetchImage(imageView: avatarImageView)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MenuCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: MenuCell.identifier)
    }
}

// MARK: - MenuViewControllerProtocol

extension MenuViewController: MenuViewControllerProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Delegate methods

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Layout.TableView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.countRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else { return UITableViewCell() }
        let cellModel = presenter.model(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as? MenuCell else { return UITableViewCell() }
        cell.update(model: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            presenter?.routeMap()
        case 1:
            presenter?.routeFines()
        case 3:
            presenter?.routeProfile()
        case 4:
            presenter?.routeSetting()
        case 6:
            presenter?.routeAuth()
        default:
            break
        }
    }
}
