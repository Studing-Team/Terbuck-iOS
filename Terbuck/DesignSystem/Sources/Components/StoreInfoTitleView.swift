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
        storeNameLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textSemi18)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byCharWrapping
        }
        
        storeAddressLabel.do {
            $0.font = DesignSystem.Font.uiFont(.captionMedium12)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack10)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(storeNameLabel, storeCategoryImage, storeAddressLabel)
    }
    
    func setupLayout() {
        storeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview()
        }
        
        storeCategoryImage.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel)
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(4)
            $0.size.equalTo(24)
        }
    }
    
    func setupStoreCategoryImage(_ type: CategoryType) {
        storeCategoryImage.image = type.colorIcon
    }
}
