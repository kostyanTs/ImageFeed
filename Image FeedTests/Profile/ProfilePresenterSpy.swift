//
//  ProfilePresenterSpy.swift
//  Image FeedTests
//
//  Created by Konstantin on 19.06.2024.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    var updateProfileDetailsDidCalled: Bool = false
    var updateAvatarDidCalled: Bool = false
    var logoutDidCalled: Bool = false
    
    func updateProfileDetails() {
        updateProfileDetailsDidCalled = true
    }
    
    func updateAvatar() {
        updateAvatarDidCalled = true
    }
    
    func logout() {
        logoutDidCalled = true
    }
}
