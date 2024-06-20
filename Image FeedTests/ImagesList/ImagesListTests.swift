//
//  ImagesListTests.swift
//  Image FeedTests
//
//  Created by Konstantin on 19.06.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    func testViewDidLoadCallsFetchPhotosNextPage() {
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        viewController.viewDidLoad()
        XCTAssertTrue(presenter.fetchPhotosNextPageDidCalled)
    }
    
    func testUploadedPhotosAfterFetchPhotos() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterMock()
        let imageService = ImagesListServiceSpy.shared
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.presenter?.fetchPhotosNextPage()
        
        XCTAssertTrue(imageService.photosWereUpdated)
    }
}
