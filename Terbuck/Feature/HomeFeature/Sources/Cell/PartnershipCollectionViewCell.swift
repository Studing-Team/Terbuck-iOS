//
//  PartnershipCollectionViewCell.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/28/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

public final class PartnershipCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var moreBenefitTapHandler: (() -> Void)?
    
    // MARK: - UI Properties

    private let benefitBackgroundImage = UIImageView()
    
    private let partnerNameStackView = UIStackView()
    private let partnerNameLabel = UILabel()
    private let partnerCategoryLabel = UILabel()
    private let categoryLabel = UILabel()
    private let partnershipImageView = UIImageView()
    
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

public extension PartnershipCollectionViewCell {
    func configureCell(forModel model: PartnershipModel) {
        partnerNameLabel.text = model.partnershipName
        partnerCategoryLabel.text = model.partnerCategoryType.title
        categoryLabel.text = model.storeType.title
        
        if model.isNewPartner {
            partnershipImageView.isHidden = false
        }
    }
}

// MARK: - Private Extensions

private extension PartnershipCollectionViewCell {
    func setupStyle() {
        partnerNameStackView.do {
            $0.axis = .horizontal
            $0.alignment = .top
            $0.addArrangedSubviews(partnerNameLabel, partnershipImageView, UIView())
        }
        
        partnerNameLabel.do {
            $0.font = .textSemi16
            $0.textColor = .terbuckBlack30
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        
        partnerCategoryLabel.do {
            $0.font = .captionMedium12
            $0.textColor = .terbuckBlack10
        }
        
        categoryLabel.do {
            $0.textAlignment = .center
            $0.font = .textSemi14
            $0.textColor = .terbuckBlack30
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .terbuckWhite5
            $0.clipsToBounds = true
        }
        
        partnershipImageView.do {
            $0.image = .selectedPartnership
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(partnerNameStackView, partnerCategoryLabel, categoryLabel)
    }
    
    func setupLayout() {
        partnerNameStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        partnerCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(partnerNameLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(partnerNameStackView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(49)
            $0.height.equalTo(33)
        }
        
        partnershipImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
    }
}
