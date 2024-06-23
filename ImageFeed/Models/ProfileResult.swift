//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Konstantin on 27.05.2024.
//

import Foundation

private enum Keys: String {
    case token
}

public struct ProfileResult: Codable {
    let id: String
    let updated_at: String
    let username: String?
    let first_name: String?
    let last_name: String?
    let twitter_username: String?
    let portfolio_url: String?
    let bio: String?
    let location: String?
    let total_likes: Int?
    let total_photos: Int?
    let total_collections: Int?
    let followed_by_user: Bool
    let downloads: Int?
    let uploads_remaining: Int?
    let instagram_username: String?
    let email: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let email: String
    let bio: String
}

struct ProfileImage: Codable {
    let profile_image: Imagesizes
    
    struct Imagesizes: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
}
