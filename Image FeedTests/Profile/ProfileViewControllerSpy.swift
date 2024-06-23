//
//  ProfileViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Konstantin on 19.06.2024.
//

import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var setAvatarDidCalled: Bool = false
    
    func updateView(profile: ImageFeed.ProfileResult) {
    }
    
    func setAvatar(url: URL) {
        setAvatarDidCalled = true
    }
}
