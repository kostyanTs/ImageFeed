//
//  ProfileTests.swift
//  Image FeedTests
//
//  Created by Konstantin on 19.06.2024.
//

@testable import ImageFeed
import XCTest


final class ProfileTests: XCTestCase {
    
    func testCallsUpdateProfileDetails() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        presenter.updateProfileDetails()
        XCTAssertTrue(presenter.updateProfileDetailsDidCalled)
    }
    
    func testCallsUpdateAvatar() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        presenter.updateAvatar()
        XCTAssertTrue(presenter.updateAvatarDidCalled)
    }
    
    func testCallsLogout() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        presenter.logout()
        XCTAssertTrue(presenter.logoutDidCalled)
    }
    
    func testProfileViewControllerSetAvatar() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        let url = Constants.defaultBaseURL
        presenter.view?.setAvatar(url: url)
        XCTAssertTrue(viewController.setAvatarDidCalled)
    }
}

