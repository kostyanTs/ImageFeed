//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Konstantin on 19.06.2024.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?{ get set }
    func fetchPhotosNextPage()
//    func didUpdatedData() -> Bool
}

final class ImagesListPresenter: ImagesListPresenterProtocol {

    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    
    init(view: ImagesListViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
//    func didUpdatedData() -> Bool {
//        guard var photos = view?.photos else { return true }
//        let oldCount = photos.count
//        let newCount = imagesListService.photos.count
//        photos = imagesListService.photos
//        return oldCount != newCount
//    }
}
