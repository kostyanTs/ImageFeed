//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Konstantin on 19.06.2024.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateProfileDetails()
    func updateAvatar()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    init(view: ProfileViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func updateProfileDetails() {
        guard let profileModel = profileService.profileInfo else { return }
        view?.updateView(profile: profileModel)
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.profileImage?.profile_image.medium,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setAvatar(url: url)
    }
    
    func logout() {
        profileLogoutService.logout()
    }
    
    
}
