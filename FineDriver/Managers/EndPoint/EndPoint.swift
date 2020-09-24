//
//  EndPoint.swift
//  FineDriver
//
//  Created by Вячеслав on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var environmentBaseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case head   = "HEAD"
}
