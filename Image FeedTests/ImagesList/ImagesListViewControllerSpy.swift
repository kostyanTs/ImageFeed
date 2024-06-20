//
//  ImagesListViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Konstantin on 19.06.2024.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    
    func viewDidLoad() {
        presenter?.fetchPhotosNextPage()
    }
}
