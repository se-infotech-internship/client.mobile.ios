//
//  Service.swift
//  FineDriver
//
//  Created by Вячеслав on 27.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

enum ServiceMethod: String {
    case put     = "PUT"
    case post    = "POST"
    case get     = "GET"
    case delete  = "DELETE"
    case head    = "HEAD"
}

// TODO: - This example  https://david.y4ng.fr/writing-your-own-network-layer/

protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: ServiceMethod { get }
}

extension Service {
    public var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        if method == .get {
            guard let parameters = parameters as? [String: String] else {
                fatalError("parameters for GET http method must conform to [String: String]")
            }
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        } else if method == .post {
            guard let parameters = parameters as? [String: String] else {
                fatalError("parameters for POST http method must conform to [String: String]")
            }
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return urlComponents?.url
    }
}
