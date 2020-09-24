//
//  HTTPTask.swift
//  FineDriver
//
//  Created by Вячеслав on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String:String]

enum HTTPTask {
    
    case request
    case requestParameters(bodyParameters: Parameters?,
                           urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)
}
