//
//  CustomHeaderCollectionReusableView.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 6/20/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

final class CustomHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - UI Components

    private let headerTitleLabel = UILabel()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension CustomHeaderCollectionReusableView {
    func setupStyle() {
        headerTitleLabel.do {
            $0.text = "최근 검색어"
            $0.font = DesignSystem.Font.uiFont(.textSemi16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(headerTitleLabel)
    }
    
    func setupLayout() {
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
        }
    }
}
