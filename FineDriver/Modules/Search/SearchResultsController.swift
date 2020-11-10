//
//  SearchResultsController.swift
//  FineDriver
//
//  Created by Вячеслав on 20.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol LocateOnTheMap: class {
    func locateWithLongitude(_ lon: Double,
                                lat: Double,
                                title: String)
}

final class SearchResultsController: UITableViewController {
    
    public var searchResults: [String]! {
        didSet{
            tableView.reloadData()
        }
    }
    weak var delegate: LocateOnTheMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResults = Array()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    //MARK:- UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: nil)
        
        guard let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&key=\(Constants.googleMapKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        print("urlPath = \(urlpath)")
        guard let url = URL(string: urlpath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, responce, error) in
            guard let jsonData = data else { return }
            print("jsonData = \(jsonData)")
            if let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                let location: LocationModel? = LocationModel(json: jsonResult)
                guard let long = location?.long,
                      let lat = location?.lat else { return }
                
                DispatchQueue.main.async {
                    self?.delegate.locateWithLongitude(long, lat: lat, title: "")
                }
            }
        }.resume()
    }
}
