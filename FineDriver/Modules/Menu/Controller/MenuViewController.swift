//
//  MenuViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol MenuViewControllerProtocol: class {
    
    func reloadData()
}

final class MenuViewController: UIViewController {

    // MARK: - Private outlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public properties
    var presenter: MenuPresenterProtocol?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        reloadData()
    }
    
    deinit {
        debugPrint("MenuViewController deinit")
    }
    
    // MARK: - Private methods
    private func setupView() {
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
    
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MenuCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: MenuCell.identifier)
    }
}

extension MenuViewController: MenuViewControllerProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Delegate methods
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        // TODO: - write code
    }
}
