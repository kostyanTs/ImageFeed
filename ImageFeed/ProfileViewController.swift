//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 26.03.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profilePhotoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let commentLabel = UILabel()
    private var logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfilePhoto(imageView: profilePhotoImageView)
        addNameLabel(label: nameLabel)
        addEmailLabel(label: emailLabel)
        addCommentLabel(label: commentLabel)
        addLogoutButton()
    }
    
    func addProfilePhoto(imageView: UIImageView) {
        let image = UIImage(named: "ProfilePhoto")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    func addNameLabel(label: UILabel) {
        label.text = "Екатерина Новикова"
        label.textColor = UIColor(named: "YP White (iOS)")
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: profilePhotoImageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    func addEmailLabel(label: UILabel) {
        label.text = "@ekaterina_nov"
        label.textColor = UIColor(named: "YP Grey (iOS)")
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: profilePhotoImageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func addCommentLabel(label: UILabel) {
        label.text = "Hello, world!"
        label.textColor = UIColor(named: "YP White (iOS)")
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: profilePhotoImageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func addLogoutButton() {
        let button = UIButton.systemButton(
            with: UIImage(named: "ExitLogout")!,
            target: self,
            action: #selector(Self.didTapButton))
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
    private func didTapButton() {}
}
