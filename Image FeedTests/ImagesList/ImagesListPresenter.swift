//
//  ImagesListPresenter.swift
//  Image FeedTests
//
//  Created by Konstantin on 19.06.2024.
//

import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var fetchPhotosNextPageDidCalled: Bool = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageDidCalled = true
    }
}
