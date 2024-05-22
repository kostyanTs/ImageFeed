//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 17.04.2024.
//

import UIKit
//import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let token = storage.token
        if token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: Segue.showAuthenticationScreenSegueIdentifier, sender: nil)
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



extension SplashViewController: AuthViewControllerDellegate {
    
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(Segue.showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
//            ProgressHUD.animate()
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service().fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
//            ProgressHUD.dismiss()
            switch result {
                case .success(let successToken):
                    storage.token = successToken
                    self.switchToTabBarController()
                case .failure:
                    break
            }
        }
    }
}

