//
//  StoreCollectionViewCell.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

public final class StoreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var moreBenefitTapHandler: (() -> Void)?
    
    // MARK: - UI Properties

    private let storeInfoTitleView = StoreInfoTitleView()
    private let benefitBackgroundImage = UIImageView()
    private let mainBenefitLabel = UILabel()
    private let moreBenefitButton = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onMoreBenefitTapped(_ handler: @escaping () -> Void) {
        self.moreBenefitTapHandler = handler
    }
}

// MARK: - Extensions

public extension StoreCollectionViewCell {
    func configureCell(forModel model: NearStoreModel) {
        storeInfoTitleView.configureData(name: model.storeName, address: model.address, category: model.cateotry)
        mainBenefitLabel.text = model.mainBenefit
        moreBenefitButton.isHidden = model.subBenefit.isEmpty
    }
}

// MARK: - Private Extensions

private extension StoreCollectionViewCell {
    func setupStyle() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = DesignSystem.Color.uiColor(.terbuckBlack5).cgColor
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
        
        mainBenefitLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textSemi16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.lineBreakMode = .byCharWrapping
        }
        
        moreBenefitButton.do {
            $0.text = "혜택 전체보기"
            $0.font = DesignSystem.Font.uiFont(.textSemi14)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckGreen50)
            $0.isUserInteractionEnabled = true
        }
        
        benefitBackgroundImage.do {
            $0.image = .benefitBackground
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(storeInfoTitleView, moreBenefitButton, benefitBackgroundImage)
        benefitBackgroundImage.addSubviews(mainBenefitLabel)
    }
    
    func setupLayout() {
        storeInfoTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(moreBenefitButton.snp.leading).inset(10)
        }
        
        moreBenefitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        benefitBackgroundImage.snp.makeConstraints {
            $0.top.equalTo(storeInfoTitleView.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(19)
        }
        
        mainBenefitLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        moreBenefitButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        moreBenefitTapHandler?()
    }
}
