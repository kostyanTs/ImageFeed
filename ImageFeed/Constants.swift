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
    static let redirectURL: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

enum Segue {
    static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationSegueIdentifier"
    static let showWebViewSegueIdentifier = "ShowWebView"
    static let showSingleImageSegueIdentifier = "ShowSingleImage"
}
