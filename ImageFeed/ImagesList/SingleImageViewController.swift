//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 28.03.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

class SingleImageViewController: UIViewController {
    
    var imageUrl: URL?
    
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var didTapBackButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1.5
//        guard let image = singleImageView.image else { return }
//        singleImageView.frame.size = image.size
//        rescaleAndCenterImageInScrollView(image: image)
        setImage()
    }
    
    private func setImage() {
        guard let imageUrl = imageUrl else { return }
        UIBlockingProgressHUD.show()
        singleImageView.kf.indicatorType = .activity
        singleImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "imagesListPlaceholder")) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let result):
                rescaleAndCenterImageInScrollView(image: result.image)
            case .failure(let error):
                print("[SingleImageViewController]: \(error)")
                guard let image = UIImage(named: "imagesListPlaceholder") else { return }
                singleImageView.image = image
                rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        scrollView.contentInset.top = 5
        scrollView.contentInset.bottom = 5
        scrollView.contentInset.left = 5
        scrollView.contentInset.right = 5
    }
    
    @IBAction func didTapBackButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapActivityButton(_ sender: Any) {
        let items = [singleImageView.image]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
}
