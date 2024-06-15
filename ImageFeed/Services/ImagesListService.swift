//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Konstantin on 13.06.2024.
//

import UIKit

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?

    static let didChangeNotification = Notification.Name(rawValue: "ImagesListProviderDidChange")
    
    private var mainUrl = "https://api.unsplash.com/"
    private var lastPage: Int?
    
    var photos: [Photo] = []
    
    private func makeRequest(page: Int) -> URLRequest? {
            guard let url = URL(string: mainUrl + "/photos?page=\(page)"),
                  let token = oauth2TokenStorage.token else {
                preconditionFailure("[ImagesListService]: Error: can't construct RequestUrl")
            }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            return request
        }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = (lastPage ?? 0)  + 1
        guard let requestWithPageNumber = makeRequest(page: nextPage) else {
            print("[ImagesListService]: error in requestWithPageNumber")
            return
        }
        
        let task = URLSession.shared.objectTask(for: requestWithPageNumber) { (result: Result<[PhotoResult],Error>) in
                switch result {
                case .success(let decodedData):
                    var arrayOfPhotos: [Photo] = []
                    decodedData.forEach { data in
                        let photo = Photo(
                            id: data.id,
                            size: CGSize(width: data.width, height: data.height),
                            createdAt: ISO8601DateFormatter().date(from: data.createdAt ?? ""),
                            welcomeDescription: data.description,
                            thumbImageURL: data.urls.thumb,
                            largeImageURL: data.urls.full,
                            isLiked: data.likedByUser
                        )
                        arrayOfPhotos.append(photo)
                    }
                    DispatchQueue.main.async {
                        self.photos += arrayOfPhotos
                        self.lastPage = nextPage
                        self.task = nil
                        NotificationCenter.default
                            .post(name: ImagesListService.didChangeNotification,
                                    object: self,
                                    userInfo: ["URL": decodedData])
                    }
                case .failure(let error):
                    print("[ImagesListService]: \(error)")
                    self.task = nil
                }
                self.task = nil
            }
            self.task = task
            task.resume()
    }
}

