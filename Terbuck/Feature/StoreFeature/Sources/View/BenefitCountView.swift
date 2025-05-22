//
//  BenefitCountView.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/13/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

public final class BenefitCountView: UIView {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    
    private let benefitStackView = UIStackView()
    
    private let benefitImageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCount(count: Int) {
        titleLabel.text = "혜택 \(count)가지"
    }
}

// MARK: - Private Extensions

private extension BenefitCountView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite5)
            $0.layer.cornerRadius = 8
        }
        
        benefitStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.distribution = .fill
            $0.addArrangedSubviews(benefitImageView, titleLabel)
        }
        
        benefitImageView.do {
            $0.image = .selectStoreIcon
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
            $0.font = DesignSystem.Font.uiFont(.captionMedium12)
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(benefitStackView)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        benefitStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        benefitImageView.snp.makeConstraints {
            $0.size.equalTo(14)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("BenefitCountView") {
    BenefitCountView()
        .showPreview()
}
#endif
