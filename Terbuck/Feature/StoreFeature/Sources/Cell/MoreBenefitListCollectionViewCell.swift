//
//  MoreBenefitListCollectionViewCell.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 6/23/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class MoreBenefitListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let moreBenefitTitleLabel = UILabel()
    
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

// MARK: - Extensions

public extension MoreBenefitListCollectionViewCell {
    func configureCell(_ beneiftTitle: String) {
        moreBenefitTitleLabel.text = beneiftTitle
    }
}

// MARK: - Private Extensions

private extension MoreBenefitListCollectionViewCell {
    func setupStyle() {
        contentView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite3)
            $0.layer.cornerRadius = 8
        }
        
        moreBenefitTitleLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textRegular14)
            $0.textColor =  DesignSystem.Color.uiColor(.terbuckBlack50)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(moreBenefitTitleLabel)
    }
    
    func setupLayout() {
        moreBenefitTitleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18)
            $0.horizontalEdges.equalToSuperview().offset(15)
        }
    }
}
