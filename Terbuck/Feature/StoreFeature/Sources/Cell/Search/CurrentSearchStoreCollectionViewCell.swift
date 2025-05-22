//
//  CurrentSearchStoreCollectionViewCell.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/21/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class CurrentSearchStoreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var moreBenefitTapHandler: (() -> Void)?
    
    // MARK: - UI Properties

    private let currentStoreNameLabel = UILabel()
    private let deleteButton = UIButton()
    
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

public extension CurrentSearchStoreCollectionViewCell {
    func configureCell(_ title: String) {
        currentStoreNameLabel.text = title
    }
}

// MARK: - Private Extensions

private extension CurrentSearchStoreCollectionViewCell {
    func setupStyle() {
        currentStoreNameLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textRegular16)
            $0.textColor =  DesignSystem.Color.uiColor(.terbuckBlack50)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(currentStoreNameLabel, deleteButton)
    }
    
    func setupLayout() {
        currentStoreNameLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalTo(deleteButton.snp.leading).inset(15)
            $0.size.equalTo(88)
        }
        
        deleteButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(30)
            $0.size.equalTo(16)
        }
    }
}

