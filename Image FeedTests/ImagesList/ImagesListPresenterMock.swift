//
//  ImagesListPresenterMocks.swift
//  Image FeedTests
//
//  Created by Konstantin on 20.06.2024.
//

import Foundation
import ImageFeed

final class ImagesListPresenterMock: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListServiceSpy.shared
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
}
