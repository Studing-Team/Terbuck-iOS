//
//  TermsListView.swift
//  Login
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit
import Combine

import DesignSystem

import SnapKit
import Then

public final class TermsListView: UIView {
    
    // MARK: - Combine Properties
    
    let tapPublisher = PassthroughSubject<Bool, Never>()
    
    // MARK: - Enum Properties
    
    public enum TermsType {
        case service
        case userInfo
        case marketing
        
        var title: String {
            switch self {
            case .service:
                return "[필수]  서비스 이용약관"
                
            case .userInfo:
                return "[필수]  개인정보 수집 및 이용동의"
                
            case .marketing:
                return "[선택]  개인정보 수집 및 이용동의"
            }
        }
    }
    
    private var termsType: TermsType
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let checkButton = AuthCheckButton()
    private let arrowImageView = ChevronImageView(type: .size20, tintColor: .terbuckBlack30)
    
    // MARK: - Init
    
    public init(type: TermsType) {
        self.termsType = type
        super.init(frame: .zero)
        
        setupStyle(type)
        setupHierarchy()
        setupLayout()
        setupButtonAction()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension TermsListView {
    func setupStyle(_ type: TermsType) {
        titleLabel.do {
            $0.text = type.title
            $0.font = .textRegular14
            $0.textColor = .terbuckBlack50
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(checkButton, titleLabel, arrowImageView)
    }
    
    func setupLayout() {
        checkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15.17)
            $0.leading.equalToSuperview().offset(18.17)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkButton)
            $0.leading.equalTo(checkButton.snp.trailing).offset(6)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(checkButton)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupButtonAction() {
        checkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        tapPublisher.send(checkButton.getButtonState())
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("TermsListView") {
    TermsListView(type: .service)
        .showPreview()
}
#endif
