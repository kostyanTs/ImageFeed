//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Konstantin on 11.04.2024.
//

import UIKit

final class OAuth2TokenStorage {
    
    private let usersDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String {
        get {
            guard let data = usersDefaults.data(forKey: Keys.token.rawValue),
                  let token = try?JSONDecoder().decode(String.self, from: data) else {
                return ""
            }
            return token
        }
        
        set {
            guard let data = try?JSONEncoder().encode(newValue) else {
                return
            }
            usersDefaults.set(data, forKey: Keys.token.rawValue)
        }
    }
}
