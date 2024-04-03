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
            guard let image = image else { return }
            singleImageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
//            scrollView.alwaysBounceVertical = true
//            scrollView.alwaysBounceVertical = true
        }
    }
    
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var didTapBackButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
//        scrollView.alwaysBounceVertical = true
//        scrollView.alwaysBounceVertical = true
        singleImageView.image = image
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1.5
        guard let image = singleImageView.image else { return }
        singleImageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)

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
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
    
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        guard let image = singleImageView.image else { return }
//        rescaleAndCenterImageInScrollView(image: image)
//    }
////
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        guard let image = singleImageView.image else { return }
//        rescaleAndCenterImageInScrollView(image: image)
//    }
//
//    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
//        scrollView.alwaysBounceVertical = true
//        scrollView.alwaysBounceVertical = true
//        guard let image = singleImageView.image else { return }
//        rescaleAndCenterImageInScrollView(image: image)
//    }
}
