//
//  StoreListModelCollectionViewCell.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/13/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class StoreListModelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var moreBenefitTapHandler: (() -> Void)?
    
    // MARK: - UI Properties

    private let storeAsyncImageView = AsyncImageView(frame: .zero)
    
    private let storeTitleStackView = UIStackView()
    
    private let storeNameLabel = UILabel()
    private let storeCategoryImageView = UIImageView()
    private let storeAddressLabel = UILabel()
    private let addressContainerView = UIView()
    private let spacerView = UIView()
    private let benefitCountView = BenefitCountView()
    private let rightArrowImageView = UIImageView()
    
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

public extension StoreListModelCollectionViewCell {
    func configureCell(forModel model: StoreListModel) {
        storeNameLabel.text = model.storeName
        storeAddressLabel.text = model.storeAddress
        benefitCountView.configureCount(count: model.benefitCount)
        storeAsyncImageView.setImage(model.imageURL, type: .storeListImage)
        
        setupStoreCategoryImage(model.category)
    }
}

// MARK: - Private Extensions

private extension StoreListModelCollectionViewCell {
    func setupStyle() {
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
        }
        
        storeAsyncImageView.do {
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }

        storeTitleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.addArrangedSubviews(storeNameLabel, storeCategoryImageView, UIView())
        }

        storeNameLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textSemi16)
            $0.textColor =  DesignSystem.Color.uiColor(.terbuckBlack50)
            $0.numberOfLines = 2
        }
        
        storeAddressLabel.do {
            $0.font = DesignSystem.Font.uiFont(.captionMedium12)
            $0.textColor =  DesignSystem.Color.uiColor(.terbuckBlack10)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byWordWrapping
        }
        
        rightArrowImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = DesignSystem.Color.uiColor(.terbuckBlack10)
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(storeAsyncImageView, storeTitleStackView, storeAddressLabel, benefitCountView, rightArrowImageView)
    }
    
    func setupLayout() {
        storeAsyncImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(15)
            $0.size.equalTo(88)
        }
        
        storeTitleStackView.snp.makeConstraints {
            $0.top.equalTo(storeAsyncImageView.snp.top).offset(1)
            $0.leading.equalTo(storeAsyncImageView.snp.trailing).offset(15)
        }

        storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(storeTitleStackView.snp.bottom).offset(4)
            $0.leading.equalTo(storeAsyncImageView.snp.trailing).offset(15)
        }
        
        benefitCountView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(storeAddressLabel.snp.bottom).offset(4) // 최소 여백
            $0.top.lessThanOrEqualTo(storeAddressLabel.snp.bottom).offset(25) // 최대 여백
            $0.leading.equalTo(storeAsyncImageView.snp.trailing).offset(15)
            $0.bottom.equalTo(storeAsyncImageView.snp.bottom).inset(1)
        }
        
        rightArrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(storeAsyncImageView)
            $0.leading.equalTo(storeTitleStackView.snp.trailing)
            $0.leading.equalTo(storeAddressLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(15)
            $0.width.equalTo(14)
        }
        
        storeCategoryImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
    }
    
    func setupStoreCategoryImage(_ type: CategoryType) {
        storeCategoryImageView.image = type.icon
    }
}

