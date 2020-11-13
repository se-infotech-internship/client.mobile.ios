//
//  SearchResultsController.swift
//  FineDriver
//
//  Created by Вячеслав on 20.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol SearchResultsProtocol: class {
    func locateWithLongitude(lon: Double,
                             lat: Double)
}

final class SearchResultsController: UITableViewController {
    
    weak var delegate: SearchResultsProtocol!
    var presenter: SearchResultsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    fileprivate func configureUI() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cellIdentifier")
    }
    
    //MARK:- UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = presenter.searchResults[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: nil)
        
        presenter.didSelectRow(index: indexPath.row)
    }
    
    #if DEBUG
    deinit { print("🟢 \(#function) \(self)") }
    #endif
}

//MARK:- SearchResultsViewProtocol

extension SearchResultsController: SearchResultsViewProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func receivedLocation(lat: Double, long: Double) {
        delegate?.locateWithLongitude(lon: long, lat: lat)
    }
}
