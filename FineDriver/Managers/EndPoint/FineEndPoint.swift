//
//  FineEndPoint.swift
//  FineDriver
//
//  Created by Вячеслав on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case baseURL
}

public enum FineApi {
    case countFines(id: String)
}

extension FineApi: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .baseURL:
            return "https://e-driver.infotech.guru"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("base URL couldn't be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .countFines(let id):
            return "\(id)/countFines"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .countFines(let id):
            return .requestParameters(bodyParameters: nil, urlParameters: ["uuid": id, "api_key": NetworkManager.apiKey])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
