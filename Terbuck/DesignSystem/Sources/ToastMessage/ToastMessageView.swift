//
//  ToastMessageView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit

import Shared

import SnapKit
import Then

final class ToastMessageView: UIView {
    
    private let titleStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let actionLabel = UILabel()
    
    // MARK: - Init
    
    init(type: ToastType) {
        super.init(frame: .zero)
        
        setupStyle(type)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension ToastMessageView {
    func setupStyle(_ type: ToastType) {
        backgroundColor = .terbuckToastBackground
        layer.cornerRadius = 16
        clipsToBounds = true
        
        titleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
            $0.addArrangedSubviews(iconImageView, titleLabel, UIView(), actionLabel)
        }
        
        iconImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = type.image
        }

        titleLabel.do {
            $0.text = type.title
            $0.font = type.font
            $0.textColor = type.fontColor
            $0.numberOfLines = 1
        }
        
        actionLabel.do {
            $0.text = type.buttonTitle
            $0.font = .captionMedium12
            $0.addBottomBorderWithAttributedString(underlineColor: .terbuckGreen10, textColor: .terbuckGreen10)
            $0.isHidden = type.buttonTitle == "" ? true: false
        }
    }
    
    func setupHierarchy() {
        self.addSubview(titleStackView)
    }
    
    func setupLayout() {
        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
}
