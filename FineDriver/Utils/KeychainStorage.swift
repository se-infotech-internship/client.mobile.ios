//
//  KeychainStorage.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 02.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import KeychainAccess

struct KeychainStorage {
    public static var accessToken: String? {
       get {
        let keychain = Keychain(service: Constants.bundleId)
           return keychain["accessToken"]
       } set {
           let keychain = Keychain(service: Constants.bundleId)
           keychain["accessToken"] = newValue
       }
    }
    
    public static var refreshToken: String? {
       get {
        let keychain = Keychain(service: Constants.bundleId)
           return keychain["refreshToken"]
       } set {
           let keychain = Keychain(service: Constants.bundleId)
           keychain["refreshToken"] = newValue
       }
    }
}
