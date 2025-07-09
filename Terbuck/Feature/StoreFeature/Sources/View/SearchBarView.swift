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

public enum SearchBarType {
    case search
    case searchResult
}

public final class SearchBarView: UIView {
    
    // MARK: - Properties
    
    private var type: SearchBarType {
        didSet {
            setupStyle()
        }
    }
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let leftMenuImageView = UIImageView()
    private let rightSearchImageView = UIImageView()
    private let placeholderLabel = UILabel()
    
    // MARK: - Init
    
    public init(
        type: SearchBarType
    ) {
        self.type = type
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureSearchType(_ type: SearchBarType) {
        self.type = type
    }
    
    public func configureSearchResultType(storeName: String) {
        self.type = .searchResult
        placeholderLabel.text = storeName
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
            if type == .search {
                $0.image = .line3
            } else {
                let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
                let image = UIImage(systemName: "chevron.left", withConfiguration: config)
                $0.image = image
                $0.tintColor = DesignSystem.Color.uiColor(.terbuckBlack30)
            }
            $0.contentMode = .scaleAspectFit
        }
        
        rightSearchImageView.do {
            if type == .search {
                $0.image = UIImage(systemName: "magnifyingglass")
                $0.tintColor = DesignSystem.Color.uiColor(.terbuckBlack5)
            } else {
                let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
                $0.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
                $0.tintColor = DesignSystem.Color.uiColor(.terbuckGreen50)
            }
            
            $0.contentMode = .scaleAspectFit
        }
        
        placeholderLabel.do {
            $0.text = "우리 대학 제휴 업체는?"
            $0.font = DesignSystem.Font.uiFont(.textRegular16)
            $0.textColor = DesignSystem.Color.uiColor(type == .search ? .terbuckBlack10 : .terbuckBlack50)
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
            $0.trailing.equalTo(rightSearchImageView.snp.leading).inset(5)
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
    SearchBarView(type: .search)
        .showPreview()
}
#endif
