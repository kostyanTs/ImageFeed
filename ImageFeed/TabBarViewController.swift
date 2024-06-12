//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 03.06.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
