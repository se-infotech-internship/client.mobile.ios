//
//  CamerasSettingViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 18.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class CamerasSettingViewController: UIViewController {

    private enum Constants {
        enum TableView {
            static let height: CGFloat = 56.0
        }
    }
    
    // MARK: - Private outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    
    // MARK: - Public property
    var presenter: CamerasSettingPresenterProtocol!
    
    // MARK: - LifeCycle
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
        tableView.register(UINib(nibName: SwitchSettingCell.identifier, bundle: nil), forCellReuseIdentifier: SwitchSettingCell.identifier)
        tableView.register(UINib(nibName: StepperSettingCell.identifier, bundle: nil), forCellReuseIdentifier: StepperSettingCell.identifier)
    }
    
    private func setupNavigationBar() {
        customNavigationBar.update(title: "КАМЕРИ")
        customNavigationBar.delegate = self
    }
}

// MARK: - Delegate methods
extension CamerasSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0...2:
            guard let model = presenter?.model(index: indexPath.row) as? SwitchItemEntity,
                  let switchCell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingCell.identifier, for: indexPath) as? SwitchSettingCell else { return UITableViewCell() }
            switchCell.update(entity: model)
            return switchCell
        case 3:
            guard let model = presenter?.model(index: indexPath.row) as? StepperEntity,
                  let stepperCell = tableView.dequeueReusableCell(withIdentifier: StepperSettingCell.identifier, for: indexPath) as? StepperSettingCell else { return UITableViewCell() }
            stepperCell.update(entity: model)
            return stepperCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - CamerasSettingViewProtocol

extension CamerasSettingViewController: CamerasSettingViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - NavigationBarDelegate method
extension CamerasSettingViewController: NavigationBarDelegate {
    func leftAction() {
        presenter?.routePop()
    }
}
