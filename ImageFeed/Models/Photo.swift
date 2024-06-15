//
//  Photo.swift
//  ImageFeed
//
//  Created by Konstantin on 13.06.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
} 
