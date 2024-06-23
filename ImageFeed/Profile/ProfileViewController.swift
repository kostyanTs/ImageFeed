//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 26.03.2024.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func setAvatar(url: URL)
    func updateView(profile: ProfileResult)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    private let profilePhotoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let commentLabel = UILabel()
    private var logoutButton = UIButton()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter(view: self)
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
        addUIViews()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.updateAvatar()
            }
        presenter?.updateAvatar()
        presenter?.updateProfileDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profilePhotoImageView.contentMode = .scaleAspectFill
        self.profilePhotoImageView.layer.cornerRadius =  self.profilePhotoImageView.frame.size.width/2
        self.profilePhotoImageView.layer.masksToBounds = true
        
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        let yesButton = UIAlertAction(
            title: "Да",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                alert.dismiss(animated: true)
                self.presenter?.logout()
                
                guard let window = UIApplication.shared.windows.first else {
                    assertionFailure("Invalid Configuration")
                    return
                }
                window.rootViewController = SplashViewController()
            }
        let noAButton = UIAlertAction(
            title: "Нет",
            style: .default) { _ in
                alert.dismiss(animated: true)
            }
        alert.addAction(yesButton)
        alert.addAction(noAButton)
        present(alert, animated: true)
    }
    
    func setAvatar(url: URL) {
        profilePhotoImageView.kf.setImage(with: url, placeholder: UIImage(named: "profilePlaceHolder"))
    }
    
    func updateView(profile: ProfileResult) {
        nameLabel.text = (profile.first_name ?? "") + " " + (profile.last_name ?? "")
        usernameLabel.text = "@" + (profile.username ?? "")
        commentLabel.text = profile.bio
    }
    
    private func addUIViews() {
        addProfilePhoto(imageView: profilePhotoImageView)
        addNameLabel(label: nameLabel)
        addUsernameLabel(label: usernameLabel)
        addCommentLabel(label: commentLabel)
        addLogoutButton()
    }
    
    private func addProfilePhoto(imageView: UIImageView) {
        let image = UIImage(named: "ProfilePhoto")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true

    }
    
    private func addNameLabel(label: UILabel) {
        label.text = "Екатерина Новикова"
        label.textColor = UIColor(named: "YP White (iOS)")
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: profilePhotoImageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addUsernameLabel(label: UILabel) {
        label.text = "@ekaterina_nov"
        label.textColor = UIColor(named: "YP Grey (iOS)")
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: profilePhotoImageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addCommentLabel(label: UILabel) {
        label.text = "Hello, world!"
        label.textColor = UIColor(named: "YP White (iOS)")
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: profilePhotoImageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addLogoutButton() {
        let button = UIButton.systemButton(
            with: UIImage(named: "ExitLogout")!,
            target: self,
            action: #selector(Self.didTapButton))
        button.accessibilityIdentifier = "LogoutButtton"
        button.tintColor = UIColor(named: "YP Red (iOS)")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.logoutButton = button
    }
    
    @objc
    private func didTapButton() {
        self.showAlert()
    }
}
