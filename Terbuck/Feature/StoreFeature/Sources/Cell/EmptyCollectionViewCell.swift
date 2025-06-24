//
//  EmptyCollectionViewCell.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 6/24/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class EmptyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let messageTitleLabel = UILabel()
    
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

private extension EmptyCollectionViewCell {
    func setupStyle() {
        messageTitleLabel.do {
            $0.text = "등록된 매장이 없습니다"
            $0.font = DesignSystem.Font.uiFont(.textSemi16)
            $0.textColor =  DesignSystem.Color.uiColor(.terbuckBlack10)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(messageTitleLabel)
    }
    
    func setupLayout() {
        messageTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
