//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Konstantin on 24.05.2024.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profileInfo: ProfileResult?
    
    private init() {}
    
    func makeProfileRequest(_ token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            preconditionFailure("Error: cant construct url")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        guard let token = OAuth2TokenStorage().token else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        guard let request = makeProfileRequest(token) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedData):
                    do {
                        self.profileInfo = decodedData
                        completion(.success(decodedData))
                           
                    }
                    catch {
                        completion(.failure(error))
                        print("[ProfileService] \(error)")
                    }
                case .failure(let error):
                    completion(.failure(error))
                    print("[ProfileService]: \(error)")
                }
            }
        }
        self.task = task
        task.resume()
    }
}
