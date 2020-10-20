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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearNavControllersStack()
    }
    
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
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        presenter?.fetchGoogleImage(imageView: avatarImageView)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MenuCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: MenuCell.identifier)
    }
    
    private func clearNavControllersStack() {
        
        guard let controllers = navigationController?.viewControllers else { return }
        
        for (index, element) in controllers.enumerated() {
            if element == self {
                navigationController?.viewControllers.removeAll(where: { (controller) -> Bool in
                    if controller != element && controller != MapViewController(nibName: "MapViewController", bundle: nil) {
                        navigationController?.viewControllers.remove(at: index)
                    }
                    return true
                })
            }
        }
        
        self.navigationController?.viewControllers = [self]
    }
}

// MARK: - Protocol methods
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
            UserDefaults.standard[.tokenId] = ""
            presenter?.routeAuth()
        default:
            break
        }
    }
}

// MARK: - Pop gesture delegate method
extension MenuViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
