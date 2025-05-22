//
//  SearchStoreCollectionViewCell.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/21/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class SearchStoreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties

    private let storeTitleStackView = UIStackView()
    
    private let storeNameLabel = UILabel()
    private let storeCategoryImageView = UIImageView()
    private let storeAddressLabel = UILabel()
    private let benefitCountView = BenefitCountView()
    private let rightArrowImageView = ChevronImageView(type: .size14, tintColor: DesignSystem.Color.uiColor(.terbuckBlack10))
    
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

public extension SearchStoreCollectionViewCell {
    func configureCell(forModel model: StoreListModel, searchTitle: String) {
        storeNameLabel.text = model.storeName
        storeAddressLabel.text = model.storeAddress
        benefitCountView.configureCount(count: model.benefitCount)

        setupStoreCategoryImage(model.category)
        changeSearchTitle(searchTitle)
    }
    
    private func setupStoreCategoryImage(_ type: CategoryType) {
        storeCategoryImageView.image = type.icon
    }
    
    private func changeSearchTitle(_ searchTitle: String) {
        guard let storeName = storeNameLabel.text else { return }
        
        let attributedText = NSMutableAttributedString(string: storeName)
        
        let range = (storeName as NSString).range(of: searchTitle, options: .caseInsensitive)
        if range.location != NSNotFound {
            attributedText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: storeNameLabel.font.pointSize), range: range)
        }
        
        storeNameLabel.attributedText = attributedText
    }
}

// MARK: - Private Extensions

private extension SearchStoreCollectionViewCell {
    func setupStyle() {
        storeTitleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.addArrangedSubviews(storeNameLabel, storeCategoryImageView, UIView())
        }

        storeNameLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textSemi16)
            $0.textColor =  DesignSystem.Color.uiColor(.terbuckBlack50)
        }
        
        storeAddressLabel.do {
            $0.font = DesignSystem.Font.uiFont(.captionMedium12)
            $0.textColor =  DesignSystem.Color.uiColor(.terbuckBlack10)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(storeTitleStackView, storeAddressLabel, benefitCountView, rightArrowImageView)
    }
    
    func setupLayout() {
        storeTitleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalTo(rightArrowImageView.snp.leading).inset(15)
        }
        
        storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(storeTitleStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalTo(rightArrowImageView.snp.leading).inset(15)
        }
        
        benefitCountView.snp.makeConstraints {
            $0.top.equalTo(storeAddressLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        rightArrowImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(44.5)
            $0.leading.equalTo(storeTitleStackView.snp.trailing)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}
