//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 10.04.2024.
//

import UIKit

protocol AuthViewControllerDellegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
//    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String)
    
}

final class AuthViewController: UIViewController {

    private let oauth2Service = OAuth2Service.shared
    var delegate: AuthViewControllerDellegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black (iOS)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(Segue.showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        print("code = \n\(code)")
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func showAlert(_ vc: UIViewController)  {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "alertIdentifier"
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        }
            
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}


