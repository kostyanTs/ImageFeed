//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Konstantin on 11.04.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    static let shared = OAuth2Service()
//    private init() {}
        
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseURL = URL(string: "https://unsplash.com")!
        let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURL)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL                          
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
        
    func fetchOAuthToken(code: String, completion: @escaping (Result<String,Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)          // 11
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request){ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let oAuthToken = try JSONDecoder().decode(OAuthTokenResponseBody.self, from:data)
                        guard let accessToken = oAuthToken.access_token else {
                            fatalError("Error: can`t decode token!")
                        }
                        completion(.success(accessToken))
                    } catch {
                        completion(.failure(error))
                        print("Error: error of requesting: \(error)")
                    }
                case .failure(let error):
                    completion(.failure(error))
                    print("Error: error of requesting: \(error)")
                }
            }
        }
        self.task = task
        task.resume()
    }
}
    

