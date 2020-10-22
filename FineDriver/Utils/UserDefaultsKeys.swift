//
//  UserDefaultsKeys.swift
//  FineDriver
//
//  Created by Вячеслав on 03.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

public extension UserDefaults.Key {
    
    static let user: UserDefaults.Key = "user"
    static let firstName: UserDefaults.Key = "firstName"
    static let familyName: UserDefaults.Key = "familyName"
    static let email: UserDefaults.Key = "email"
    static let tokenId: UserDefaults.Key = "tokenId"
    static let avatarURL: UserDefaults.Key = "avatarURL"
    static let distanceToCamera: UserDefaults.Key = "distanceToCamera"
}
