//
//  UniversityListView.swift
//  Login
//
//  Created by ParkJunHyuk on 4/12/25.
//

import UIKit
import Combine

import DesignSystem

import SnapKit
import Then

public final class UniversityListView: UIView {
    
    // MARK: - Combine Properties
    
    let tapPublisher = PassthroughSubject<Bool, Never>()
    
    // MARK: - Enum Properties
    
    public enum University {
        case kw
        case ss
        
        var title: String {
            switch self {
            case .kw:
                return "광운대학교"
            case .ss:
                return "서울과학기술대학교"
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let checkButton = AuthCheckButton()
    
    // MARK: - Init
    
    public init(type: University) {
        super.init(frame: .zero)
        
        self.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite5)
        self.layer.cornerRadius = 6
        setupStyle(type)
        setupHierarchy()
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension UniversityListView {
    func setupStyle(_ type: University) {
        titleLabel.do {
            $0.text = type.title
            $0.font = DesignSystem.Font.uiFont(.textRegular14)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(titleLabel, checkButton)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17.5)
            $0.leading.equalToSuperview().offset(16)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("UniversityListView") {
    UniversityListView(type: .kw)
        .showPreview()
}
#endif
