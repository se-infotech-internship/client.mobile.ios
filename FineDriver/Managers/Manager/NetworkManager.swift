//
//  NetworkManager.swift
//  FineDriver
//
//  Created by Вячеслав on 24.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be auth first"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We couldn't decode the response"
}

enum Result<String> {
    case success
    case failure(String)
}


struct NetworkManager {
    
    static let environment: NetworkEnvironment = .baseURL
    static let apiKey = "" // YOUR_API_KEY
    private let router = Router<FineApi>() // TODO: - For example
    
    func getCountFines(uuid: String, completion: @escaping (_ countFines: Int?, _ error: String?) -> Void) {
        
        router.request(.countFines(id: uuid)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(FineApiResponse.self, from: responseData)
                        completion(apiResponse.countFines, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
            switch response.statusCode {
            case 200...299: return .success
            case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
            case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
            case 600: return .failure(NetworkResponse.outdated.rawValue)
            default: return .failure(NetworkResponse.failed.rawValue)
            }
        }
}

