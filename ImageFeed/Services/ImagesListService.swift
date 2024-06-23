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
    private let dateFormatterISO8601 = ISO8601DateFormatter()
    
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
        
        let task = URLSession.shared.objectTask(for: requestWithPageNumber) { [weak self] (result: Result<[PhotoResult],Error>) in
            guard let self = self else {
                print("[ImagesListService]: fetchPhotoNextPage error with URLSession.shared.objectTask")
                return
            }
                switch result {
                case .success(let decodedData):
                    var arrayOfPhotos: [Photo] = []
                    decodedData.forEach { data in
                        let photo = Photo(
                            id: data.id,
                            size: CGSize(width: data.width, height: data.height),
                            createdAt: self.dateFormatterISO8601.date(from: data.createdAt ?? ""),
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
    
    private func likePhotoRequest(photoId: String) -> URLRequest? {
        guard let url = URL(string: mainUrl + "photos/\(photoId)/like"),
              let token = oauth2TokenStorage.token
        else {
            preconditionFailure("[ImagesListService]: Error: can't construct likePhotoRequest")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard task == nil else { return }
        guard var likePhotoRequest = likePhotoRequest(photoId: photoId) else {
            print("[ImagesListServices]: can't construct likePhotoRequest")
            return
        }
        likePhotoRequest.httpMethod = isLike ? "DELETE" : "POST"
        let task = urlSession.objectTask(for: likePhotoRequest) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else {
                print("[ImagesListService]: changeLike error with URLSession.shared.objectTask")
                return
            }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                    completion(.success(Void()))
                }
            case .failure(let error):
                completion(.failure(error))
                print("[ImagesListService]: changeLike error with case .failure ")
            }
            self.task = nil
        }
        task.resume()
    }
}

