//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Konstantin on 14.03.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell, completion: @escaping (Bool) -> Void)
}

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var imageListView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageListView.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked(sender: Any) {
        delegate?.imageListCellDidTapLike(self) { [weak self] isLiked in
            guard let self = self else {
                print("[ImagesListCell]: likeButtonClicked error in delegate?.imageListCellDidTapLike")
                return
            }
            self.setLike(isLike: isLiked)
        }
    }
    
    func setLike(isLike: Bool) {
        guard let imageLike = UIImage(named: isLike ? "yesLike" : "noLike") else { return }
        self.likeButton.setImage(imageLike, for: .normal)
    }
}
