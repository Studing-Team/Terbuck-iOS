//
//  InformationTitleView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/27/25.
//

import UIKit

import SnapKit
import Then

public final class InformationTitleView: UIView {
    
    // MARK: - Enum Properties
    
    public enum InformationViewType {
        case termsView
        case university
        case major(String)
        
        var title: String {
            switch self {
            case .termsView: return "약관동의"
            case .university: return "나의 대학교"
            case .major(let universityName): return universityName
            }
        }
        
        var subTitle: String {
            switch self {
            case .termsView:
                return "서비스 이용을 위해 이용약관 동의가 필요해요"
                
            case .university:
                return "재학 중인 대학교에서 알맞는 혜택을 누려봐요!"
                
            case .major:
                return "더 자세한 혜택을 위해 소속 대학을 알려주세요"
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    // MARK: - Init
    
    public init(type: InformationViewType) {
        super.init(frame: .zero)
        
        setupStyle(type)
        setupHierarchy()
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupTitleText(_ name: String) {
        titleLabel.text = name
    }
}

// MARK: - Private Extensions

private extension InformationTitleView {
    func setupStyle(_ type: InformationViewType) {
        titleLabel.do {
            $0.text = type.title
            $0.font = DesignSystem.Font.uiFont(.titleBold24)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        }
        
        subTitleLabel.do {
            $0.text = type.subTitle
            $0.font = DesignSystem.Font.uiFont(.textRegular16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
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

#Preview("InformationTitleView") {
    InformationTitleView(type: .termsView)
        .showPreview()
}
#endif
