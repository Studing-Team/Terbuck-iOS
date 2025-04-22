//
//  CustomNavigationView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit

import Shared

import SnapKit
import Then

public final class CustomNavigationView: UIView {
    
    // MARK: - Properties
    
    private var backAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let separator = UIView()
    
    // MARK: - Init
    
    public init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapBack() {
        backAction?()
    }

    public func setupBackButtonAction(_ action: @escaping () -> Void) {
        self.backAction = action
    }
}

// MARK: - Private Extensions

private extension CustomNavigationView {
    func setupStyle() {
        titleLabel.do {
            $0.font = .textSemi18
            $0.textColor = .terbuckBlack50
            $0.textAlignment = .center
        }
        
        backButton.do {
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            let image = UIImage(systemName: "chevron.left", withConfiguration: config)
            $0.setImage(image, for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        }
        
        separator.do {
            $0.backgroundColor = .terbuckWhite5
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(backButton, titleLabel, separator)
    }
    
    func setupLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(56)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        
        separator.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.5)
        }
    }
}
