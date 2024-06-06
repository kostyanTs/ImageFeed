//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 17.04.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLogo(imageView: logoImageView)
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let token = storage.token
        if token != nil {
            guard let token = OAuth2TokenStorage().token else { return }
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
            guard let token = storage.token else { return }
            self.fetchProfile(token)
        }
        switchToTabBarController()
    }
}

extension SplashViewController {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service().fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
                case .success(let successToken):
                    storage.token = successToken
                    self.didAuthenticate()
                case .failure:
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

