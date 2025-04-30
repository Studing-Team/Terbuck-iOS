//
//  CustomHeaderCollectionReusableView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/28/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

public final class CustomHeaderCollectionReusableView: UICollectionReusableView{
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
    // MARK: - Init
    
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
        titleLabel.do {
            $0.text = "NEW"
            $0.font = .textSemi18
            $0.textColor = .terbuckBlack50
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(titleLabel)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
//            $0.centerY.equalToSuperview()
        }
    }
}
