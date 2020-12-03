//
//  VehicleListViewController.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 03.12.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class VehicleListViewController: BaseViewController {
    
    // MARK:- Private outlets
    @IBOutlet fileprivate weak var customNavigationBar: NavigationBar!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var presenter: VehicleListPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    fileprivate func configureUI() {
        setupNavigationBar()
        
        tableView.register(cellType: VehicleListCell.self)
        tableView.register(UINib(nibName: "VehicleHeaderView", bundle: nil),
                           forHeaderFooterViewReuseIdentifier: "VehicleHeaderView")

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Private methods
    
    fileprivate func setupNavigationBar() {
        customNavigationBar.delegate = self
        customNavigationBar.update(title: "АВТОПАРК")
    }
    
    // MARK: - Private action
    
    @IBAction fileprivate func registerAction(_ sender: Any) {
        AppCoordinator.shared.routeToSignIn(signingup: true)
    }
    
    @IBAction fileprivate func addAction(_ sender: Any) {
        AppCoordinator.shared.routeToNewNewVehicle()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension VehicleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "VehicleHeaderView" ) as! VehicleHeaderView

        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleListCell", for: indexPath) as? VehicleListCell else { return UITableViewCell() }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        AppCoordinator.shared.routeToFinesList()
    }
}

//MARK:- VehicleListProtocol

extension VehicleListViewController: VehicleListProtocol {
    
    func reloadData() {
        
    }
    
}
