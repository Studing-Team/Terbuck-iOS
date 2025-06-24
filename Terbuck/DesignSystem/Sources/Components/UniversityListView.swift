//
//  UniversityListView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/27/25.
//

import UIKit
import Combine

import Shared

import SnapKit
import Then

public final class UniversityListView: UIView {
    
    // MARK: - Combine Properties
    
    public let tapPublisher = PassthroughSubject<Bool, Never>()
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let checkButton = AuthCheckButton(type: .notBorder)
    
    // MARK: - Init
    
    public init(type: University) {
        super.init(frame: .zero)
        
        self.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite3)
        self.layer.cornerRadius = 6
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(listTapped))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        
        setupStyle(type)
        setupHierarchy()
        setupLayout()
        setupButtonAction()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeButtonState(isSelect: Bool) {
        self.checkButton.changeButtonState(isSelect: isSelect)
        self.titleLabel.textColor = isSelect == true ? DesignSystem.Color.uiColor(.terbuckBlack50) : DesignSystem.Color.uiColor(.terbuckBlack30)
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
    
    func setupButtonAction() {
        checkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        tapPublisher.send(checkButton.getButtonState())
    }
    
    @objc private func listTapped() {
        tapPublisher.send(checkButton.getButtonState())
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
