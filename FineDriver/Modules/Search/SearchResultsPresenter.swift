//
//  SearchResultsPresenter.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 12.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol SearchResultsViewProtocol: class {
    func reloadData()
    func receivedLocation(lat: Double, long: Double)
}

protocol SearchResultsPresenterProtocol {
    var searchResults: [String] { get set }
    var delegate: SearchResultsViewProtocol? { get }
    
    func didSelectRow(index: Int)
}

final class SearchResultsPresenter: SearchResultsPresenterProtocol {
    var searchResults = [String]() {
        didSet{
            delegate?.reloadData()
        }
    }
    weak var delegate: SearchResultsViewProtocol?
    
    init(delegate: SearchResultsViewProtocol) {
        self.delegate = delegate
    }
}

//MARK:- SearchResultsPresenterProtocol

extension SearchResultsPresenter {
    
    func didSelectRow(index: Int) {
        guard let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(searchResults[index])&key=\(Constants.googleMapKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
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
                    self?.delegate?.receivedLocation(lat: lat, long: long)
                }
            }
        }.resume()
    }
    
}
