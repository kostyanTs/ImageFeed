//
//  ViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 06.03.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let imagesListService = ImagesListService.shared
    
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateTableViewAnimated()
                }
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let imageUrl = URL(string: photos[indexPath.row].largeImageURL)
            viewController.singleImageView.kf.setImage(with: imageUrl)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        let thumbImageUrl = URL(string: photos[indexPath.row].thumbImageURL)
//        guard let imageUrl = thumbImageUrl else { return }
//        cell.imageListView?.kf.setImage(with: imageUrl, placeholder: UIImage(named: ""))
        guard let image = UIImage(named: "imagesListPlaceholder") else { return }
        cell.imageListView.image = image
        guard let date = photos[indexPath.row].createdAt else {
            cell.dateLabel.text = ""
            return
        }
        cell.dateLabel?.text = dateFormatter.string(from: date)
 
        let isLiked = photos[indexPath.row].isLiked
        let likeImage = isLiked ? UIImage(named: "yesLike") : UIImage(named: "noLike")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imagesListCell, with: indexPath)
        guard let thumbImageUrl = URL(string: photos[indexPath.row].largeImageURL),
              let imageView = imagesListCell.imageListView
        else {
            return imagesListCell
        }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: thumbImageUrl, placeholder: UIImage(named: "imagesListPlaceholder")) { result in
            switch result {
            case .success(_):
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("[ImagesListViewController]: \(error)")
            }
        }
        return imagesListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

