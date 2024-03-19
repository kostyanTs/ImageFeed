//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Konstantin on 14.03.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var imageListView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
}
