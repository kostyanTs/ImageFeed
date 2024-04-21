//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Konstantin on 11.04.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let access_token: String?
    let token_type: String
    let scope: String
    let created_at: Int
}
