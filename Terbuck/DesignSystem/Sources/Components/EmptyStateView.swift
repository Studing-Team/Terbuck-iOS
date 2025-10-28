//
//  EmptyStateView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 8/10/25.
//

import UIKit

import Shared

import SnapKit
import Then

public enum EmptyStateSubmitType {
    case notRequest
    case completeRequest
    
    var title: String {
        switch self {
        case .notRequest: return "아직 등록된 제휴 정보가 없어요"
        case .completeRequest: return "요청완료!"
        }
    }
    
    var subTitle: String {
        switch self {
        case .notRequest: return "요청해주시면 빠르게 확인한 후\n학교 주변 제휴 혜택을 열어드릴게요!"
        case .completeRequest: return "요청 인원이 많을수록\n더 빠르게 제휴 혜택이 열려요!"
        }
    }
    
    var font: UIFont {
        switch self {
        case .notRequest: return DesignSystem.Font.uiFont(.gmarketTitleBold20)
        case .completeRequest: return DesignSystem.Font.uiFont(.gmarketTitleBold36)
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .notRequest:
            return DesignSystem.Color.uiColor(.terbuckBlack30)
        case .completeRequest:
            return DesignSystem.Color.uiColor(.terbuckGreen50)
        }
    }
}

public final class EmptyStateView: UIView {

    // MARK: - Properties
    
    private var type: EmptyStateSubmitType {
        didSet {
            setupStyle()
        }
    }
    
    // MARK: - UI Components

    private let backgroundImage = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    // MARK: - Init
    
    public init(
        type: EmptyStateSubmitType
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
    
    public func changeState(_ type: EmptyStateSubmitType) {
        self.type = type
    }
}

// MARK: - Private Extensions

private extension EmptyStateView {
    func setupStyle() {
        backgroundImage.do {
            $0.image = UIImage.noDataBackground
            $0.contentMode = .scaleAspectFill
        }
        
        titleLabel.do {
            $0.text = type.title
            $0.font = type.font
            $0.textColor = type.titleColor
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.text = type.subTitle
            $0.font = DesignSystem.Font.uiFont(.textMedium18)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack10)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.setLineSpacing(lineSpacing: 6)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(backgroundImage, titleLabel, subTitleLabel)
    }
    
    func setupLayout() {
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("EmptyStateView") {
    EmptyStateView(type: .completeRequest)
        .showPreview()
}
#endif
