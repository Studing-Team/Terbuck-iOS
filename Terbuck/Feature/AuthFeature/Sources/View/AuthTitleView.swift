//
//  AuthTitleView.swift
//  Login
//
//  Created by ParkJunHyuk on 4/12/25.
//

import UIKit
import Combine

import DesignSystem

import SnapKit
import Then

public final class AuthTitleView: UIView {
    
    // MARK: - Combine Properties
    
    let tapPublisher = PassthroughSubject<Bool, Never>()
    
    // MARK: - Enum Properties
    
    public enum AuthViewType {
        case termsView
        case university
        
        var title: String {
            switch self {
            case .termsView:
                return "약관동의"
                
            case .university:
                return "나의 대학교"
            }
        }
        
        var subTitle: String {
            switch self {
            case .termsView:
                return "서비스 이용을 위해 이용약관 동의가 필요해요"
                
            case .university:
                return "재학 중인 대학교에서 알맞는 혜택을 누려봐요!"
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    // MARK: - Init
    
    public init(type: AuthViewType) {
        super.init(frame: .zero)
        
        setupStyle(type)
        setupHierarchy()
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension AuthTitleView {
    func setupStyle(_ type: AuthViewType) {
        titleLabel.do {
            $0.text = type.title
            $0.font = .titleBold24
            $0.textColor = .terbuckBlack50
        }
        
        subTitleLabel.do {
            $0.text = type.subTitle
            $0.font = .textRegular16
            $0.textColor = .terbuckBlack50
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(titleLabel, subTitleLabel)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(convertByHeightRatio(8))
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("AuthTitleView") {
    AuthTitleView(type: .termsView)
        .showPreview()
}
#endif
