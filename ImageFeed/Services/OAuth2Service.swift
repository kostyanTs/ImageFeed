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
    
    private init() {}
        
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            preconditionFailure("Error: unable to construct baseUrl")
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURL)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL                          
        ) else {
            assertionFailure("Error: failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
        
    func fetchOAuthToken(code: String, completion: @escaping (Result<String,Error>) -> Void) {
        print(code)
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request){ (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                print(result)
                switch result {
                case .success(let decodedData):
                    guard let accessToken = decodedData.access_token else {
                        fatalError("Error: can`t decode token!")
                    }
                    self.task = nil
                    self.lastCode = nil
                    completion(.success(accessToken))
                case .failure(let error):
                    self.task = nil
                    self.lastCode = nil
                    completion(.failure(error))
                    print("Error: error of requesting: \(error)")
                }
            }
        }
        self.task = task
        task.resume()
    }
}
    

