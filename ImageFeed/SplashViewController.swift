//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 17.04.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauthService = OAuth2Service.shared
    
    weak var authViewController: AuthViewController?
    
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLogo(imageView: logoImageView)
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let token = oauth2TokenStorage.token
        if token != nil {
            guard let token = oauth2TokenStorage.token else { return }
            fetchProfile(token)
        } else {
            switchToAuthView()
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    private func addLogo(imageView: UIImageView) {
        imageView.image = UIImage(named: "VectorImage")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func switchToAuthView() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let viewController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController,
              let authViewController = viewController.viewControllers[0] as? AuthViewController
        else {
            assertionFailure("Failed to prepare for \(Segue.showAuthenticationScreenSegueIdentifier)")
            return
        }
        authViewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}



extension SplashViewController: AuthViewControllerDellegate {
    
    func didAuthenticate() {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else {return }
            guard let token = oauth2TokenStorage.token else { return }
            self.fetchProfile(token)
        }
        switchToTabBarController()
    }
}

extension SplashViewController {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code, vc)
        }
    }
    
    private func fetchOAuthToken(_ code: String,_ vc: AuthViewController ) {
        UIBlockingProgressHUD.show()
        oauthService.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
                case .success(let successToken):
                    oauth2TokenStorage.token = successToken
                    self.didAuthenticate()
                case .failure(let error):
                authViewController?.showAlert(vc)
                print("[SplashViewController]: \(error)")
                    break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profileResult):
                guard let username = profileResult.username else { return }
                self.fetchProfileImage(token, username)
            case .failure:
                break
            }
        }
    }
    
    private func fetchProfileImage(_ token: String, _ username: String) {
        profileImageService.fetchProfileImage(token, username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.switchToTabBarController()
            case .failure(_):
                break
            }
        }
    }
}

