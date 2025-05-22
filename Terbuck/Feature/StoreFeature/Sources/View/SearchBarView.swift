//
//  SearchBarView.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/21/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

public final class SearchBarView: UIView {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let leftMenuImageView = UIImageView()
    private let rightSearchImageView = UIImageView()
    private let placeholderLabel = UILabel()
//    private let textField = UITextField()
    
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
}

// MARK: - Private Extensions

private extension SearchBarView {
    func setupStyle() {
        containerView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
            $0.layer.cornerRadius = 16
        }
        
        leftMenuImageView.do {
            $0.image = .line3
            $0.contentMode = .scaleAspectFit
        }
        
        rightSearchImageView.do {
            $0.image = UIImage(systemName: "magnifyingglass")
            $0.tintColor = DesignSystem.Color.uiColor(.terbuckBlack5)
            $0.contentMode = .scaleAspectFit
        }
        
        placeholderLabel.do {
            $0.text = "우리 대학 제휴 업체는?"
            $0.font = DesignSystem.Font.uiFont(.textRegular16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack10)
        }
    }
    
    func setupHierarchy() {
        self.addSubview(containerView)
        containerView.addSubviews(leftMenuImageView, rightSearchImageView, placeholderLabel)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftMenuImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.size.equalTo(24)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(14.5)
            $0.leading.equalTo(leftMenuImageView.snp.trailing).offset(12)
        }
        
        rightSearchImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("SearchBarView") {
    SearchBarView()
        .showPreview()
}
#endif
