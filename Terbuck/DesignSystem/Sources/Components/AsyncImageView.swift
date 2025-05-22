//
//  AsyncImageView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/9/25.
//

import UIKit

import Shared

public final class AsyncImageView: UIView {

    // MARK: - Properties

    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Public

    public func setImageData(_ data: Data?, type: ImageType) {
        activityIndicator.stopAnimating()
        
        guard let data = data, let image = UIImage(data: data) else {
            setDefaultImage(for: type)
            return
        }

        imageView.image = image
        
        if type == .storelist {
            imageView.layer.cornerRadius = 8
        }
    }

    public func setLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    // MARK: - Private

    private func setupView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    private func setDefaultImage(for type: ImageType) {
//        switch type {
//        case .partnership:
//
//        case .storelist:
//
//        case .detailStore:
//
//        case .largeDetailStore:
//
//        }
    }
}
