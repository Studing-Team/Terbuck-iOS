//
//  BenefitListCollectionViewCell.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 6/29/25.
//

import UIKit

import Shared

import SnapKit
import Then

public final class BenefitListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties

    private let containerStackView = UIStackView()
    private let titleLabel = UILabel()
    private let detailStackView = UIStackView()
    
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

public extension BenefitListCollectionViewCell {
    func configureCell(with model: StoreBenefitsModel) {
        titleLabel.text = model.title
        detailStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        model.details.forEach { detail in
            // 수평 스택 생성
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 6
            horizontalStack.alignment = .top

            // 점(label) 생성
            let bulletLabel = UILabel()
            bulletLabel.text = "∙"
            bulletLabel.font = DesignSystem.Font.uiFont(.textRegular16)
            bulletLabel.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)

            // 내용(label) 생성
            let detailLabel = UILabel()
            detailLabel.text = detail
            detailLabel.font = DesignSystem.Font.uiFont(.textRegular16)
            detailLabel.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
            detailLabel.numberOfLines = 0
            detailLabel.lineBreakMode = .byWordWrapping

            // 수평 스택에 추가
            horizontalStack.addArrangedSubview(bulletLabel)
            horizontalStack.addArrangedSubview(detailLabel)

            // 메인 수직 스택에 추가
            detailStackView.addArrangedSubview(horizontalStack)
        }
    }
}

// MARK: - Private Extensions

private extension BenefitListCollectionViewCell {
    func setupStyle() {
        containerStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        titleLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textRegular16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byClipping
        }
        
        detailStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fill
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(containerStackView)
        containerStackView.addArrangedSubviews(titleLabel, detailStackView)
    }
    
    func setupLayout() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
