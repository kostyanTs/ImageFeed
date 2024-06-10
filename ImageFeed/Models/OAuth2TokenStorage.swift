//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Konstantin on 11.04.2024.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            guard let token = KeychainWrapper.standard.string(forKey: "Auth token")  else {
                return nil
            }
            return token
        }
        
        set {
            guard let token = newValue else {
                return
            }
            KeychainWrapper.standard.set(token, forKey: "Auth token")
        }
    }
}
