//
//  ImagesListServiceSpy.swift
//  Image FeedTests
//
//  Created by Konstantin on 20.06.2024.
//
import Foundation
import ImageFeed

final class ImagesListServiceSpy {
    
    static let shared = ImagesListServiceSpy()
    private (set) var photos: [Photo] = []
    var photosWereUpdated: Bool = false
        
    func fetchPhotosNextPage() {
        photosWereUpdated = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
}
