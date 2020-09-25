//
//  PhotoView.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-06.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

class PhotoView: UIView {
    private var imageDownloader = ImageDownloader()
    private var screenScale: CGFloat { return UIScreen.main.scale }

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let username: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white

        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = .zero

        return label
    }()

    func prepareForReuse() {
        imageView.backgroundColor = .clear
        imageView.image = nil
        imageDownloader.cancel()
    }

    // MARK: - Setup

    init() {
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(username)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            username.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            username.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            username.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with photo: UnsplashPhoto, showsUsername: Bool = true) {
        imageView.backgroundColor = photo.color
        username.text = photo.user.displayName
        downloadImage(with: photo)
    }

    private func downloadImage(with photo: UnsplashPhoto) {
        guard let regularUrl = photo.urls[.regular] else { return }

        let url = sizedImageURL(from: regularUrl)

        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
            guard let strongSelf = self, strongSelf.imageDownloader.isCancelled == false else { return }

            if isCached {
                strongSelf.imageView.image = image
            } else {
                UIView.transition(with: strongSelf, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }, completion: nil)
            }
        })
    }

    private func sizedImageURL(from url: URL) -> URL {
        let width: CGFloat = frame.width * screenScale
        let height: CGFloat = frame.height * screenScale

        return url.appending(queryItems: [
            URLQueryItem(name: "max-w", value: "\(width)"),
            URLQueryItem(name: "max-h", value: "\(height)")
        ])
    }

    // MARK: - Utility

    class func view(with photo: UnsplashPhoto) -> PhotoView? {
        let photoView = PhotoView()
        photoView.configure(with: photo)
        return photoView
    }
}
