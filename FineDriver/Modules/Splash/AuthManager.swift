//
//  AuthManager.swift
//  FineDriver
//
//  Created by THXDBase on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case stub
}

struct AuthObj {}

protocol AuthManagerProtocol {
    func auth(completion: @escaping(Result<AuthObj, AuthError>) -> Void)
}

final class AuthManager: AuthManagerProtocol {
    func auth(completion: @escaping (Result<AuthObj, AuthError>) -> Void) {
        //TODO: - implement
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(AuthObj()))
        }
    }
    
    
}
