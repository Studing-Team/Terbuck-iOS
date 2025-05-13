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
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
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
