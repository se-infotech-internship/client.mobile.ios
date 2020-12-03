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
    @IBOutlet fileprivate weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var customNavigationBar: NavigationBar!

    fileprivate var oldContentOffset = CGPoint.zero
    
    fileprivate var statusBarStyle = UIStatusBarStyle.default {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }

    // MARK: - Public properties
    var presenter: MenuPresenterProtocol!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupView()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private methods
    private func setupView() {
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        
        presenter?.fetchImage(imageView: avatarImageView)
    }
    
    private func setupNavigationBar() {
        customNavigationBar.delegate = self
        customNavigationBar.update(title: "НАЛАШТУВАННЯ")
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MenuCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: MenuCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        return presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellModel = presenter.model(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as? MenuCell else { return UITableViewCell() }
        cell.update(model: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
//        case 0:
//            presenter?.routeMap()
        case 0:
            presenter?.routeFines()
        case 2:
            presenter?.routeProfile()
        case 3:
            presenter?.routeSetting()
        case 7:
            presenter?.routeAuth()
        default:
            break
        }
    }
}

extension MenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}
