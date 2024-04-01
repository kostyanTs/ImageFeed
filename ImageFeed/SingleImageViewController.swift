//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 28.03.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
        }
    }
    
    @IBOutlet weak var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        singleImageView.image = image
    }
}
