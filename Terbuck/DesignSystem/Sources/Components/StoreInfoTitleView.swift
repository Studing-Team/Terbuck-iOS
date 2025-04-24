//
//  StoreInfoTitleView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit

import Shared

import SnapKit
import Then

public final class StoreInfoTitleView: UIView {

    // MARK: - UI Components
    
    private let storeInfoStackView = UIStackView()
    private let storeNameInfoStackView = UIStackView()
    
    private let storeCategoryImage = UIImageView()
    private let storeNameLabel = UILabel()
    private let storeAddressLabel = UILabel()
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureData(name: String, address: String, category: CategoryType) {
        storeNameLabel.text = name
        storeAddressLabel.text = address
        setupStoreCategoryImage(category)
    }
}

// MARK: - Private Extensions

private extension StoreInfoTitleView {
    func setupStyle() {
        storeInfoStackView.do {
            $0.axis = .vertical
            $0.spacing = 6
            $0.alignment = .leading
            $0.addArrangedSubviews(storeNameInfoStackView, storeAddressLabel)
        }
        
        storeNameInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.addArrangedSubviews(storeNameLabel, storeCategoryImage)
        }
        
        storeNameLabel.do {
            $0.font = .titleSemi20
            $0.textColor = .terbuckBlack50
        }
        
        storeAddressLabel.do {
            $0.font = .captionMedium12
            $0.textColor = .terbuckBlack10
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(storeInfoStackView)
    }
    
    func setupLayout() {
        storeInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        storeCategoryImage.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    func setupStoreCategoryImage(_ type: CategoryType) {
        let image: UIImage
        
        switch type {
        case .bar:
            image = .barColorIcon
        case .cafe:
            image = .cafeColorIcon
        case .culture:
            image = .cultureColorIcon
        case .gym:
            image = .gymColorIcon
        case .hospital:
            image = .hospitalColorIcon
        case .restaurant:
            image = .restaurantColorIcon
        case .study:
            image = .studyColorIcon
        }
        
        storeCategoryImage.image = image
    }
}
