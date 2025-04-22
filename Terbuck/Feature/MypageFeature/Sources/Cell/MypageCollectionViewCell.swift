//
//  MypageCollectionViewCell.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/18/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

public final class MypageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let chevronImageView = ChevronImageView(type: .size14, tintColor: .terbuckBlack10)
    
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

public extension MypageCollectionViewCell {
    func configureCell(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private Extensions

private extension MypageCollectionViewCell {
    func setupStyle() {
        titleLabel.do {
            $0.font = .textRegular14
            $0.textColor = .terbuckBlack50
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(titleLabel, chevronImageView)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(21.5)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

