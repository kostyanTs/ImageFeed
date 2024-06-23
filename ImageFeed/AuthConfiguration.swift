//
//  Constants.swift
//  ImageFeed
//
//  Created by Konstantin on 08.04.2024.
//

import Foundation

enum Constants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let accessKey: String = "chQEaSadhuYmISghGUogXh_vd0M9N6Om9Wyd86aPvAU"
    static let secretKey: String = "w0qG4y0IJRcFDWJ-reDhPI65VUqyO5JTJYqQRkWSBgE"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

enum Segue {
    static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationSegueIdentifier"
    static let showWebViewSegueIdentifier = "ShowWebView"
    static let showSingleImageSegueIdentifier = "ShowSingleImage"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
}
