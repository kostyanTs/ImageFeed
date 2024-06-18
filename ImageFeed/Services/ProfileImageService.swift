//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Konstantin on 29.05.2024.
//

import UIKit

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?

    private(set) var profileImage: ProfileImage?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    func makeProfileImageRequest(token: String, username: String?) -> URLRequest? {

        let urlProfile = "https://api.unsplash.com/users/"
        guard let username = username else { preconditionFailure("Error: cant construct url") }
        let urlImage = urlProfile + username
        guard let url = URL(string: urlImage) else {
            preconditionFailure("Error: cant construct url")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchProfileImage(_ token: String, _ username: String, completion: @escaping (Result<ProfileImage, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        guard let token = oauth2TokenStorage.token else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        guard let request = makeProfileImageRequest(token: token, username: username) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileImage, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedData):
                    self.profileImage = decodedData
                    self.task = nil
                    completion(.success(decodedData))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": decodedData])
                case .failure(let error):
                    self.task = nil
                    completion(.failure(error))
                    print("Error: error of requesting: \(error)")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func deleteProfileAvatar() {
        self.profileImage = nil
    }
}

    
    
