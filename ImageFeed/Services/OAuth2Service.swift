//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Konstantin on 11.04.2024.
//

import Foundation

final class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    static let shared = OAuth2Service() // 1
//    private init() {}
        
    func makeOAuthTokenRequest(code: String) -> URLRequest {
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
        
        let request = makeOAuthTokenRequest(code: code)
        let task = URLSession.shared.data(for: request){ result in
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
            
            task.resume()
        }
}
    

