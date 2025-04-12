//
//  AuthCheckButton.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit

import Resource

import SnapKit

public final class AuthCheckButton: UIButton {
    
    // MARK: - Enum Properties
    
    public enum ButtonState {
        case activate
        case deactivate
        
        mutating func toggle() {
            self = self == .activate ? .deactivate : .activate
        }
    }
    
    // MARK: - Properties
    
    private var buttonState: ButtonState {
        didSet {
            updateButtonState()
        }
    }
    
    // MARK: - Init
    
    public init(buttonState: ButtonState = .deactivate) {
        self.buttonState = buttonState
        super.init(frame: .zero)
        setupButton()
        updateButtonState()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getButtonState() -> Bool {
        return self.buttonState == .activate ? true : false
    }
}

// MARK: - Private Extensions

private extension AuthCheckButton {
    func setupButton() {
        
        self.snp.makeConstraints {
            $0.size.equalTo(22)
        }
        
        self.layer.cornerRadius = 11
        self.clipsToBounds = true
    }
    
    func updateButtonState() {
        var config: UIButton.Configuration

        switch buttonState {
        case .activate:
            config = .filled()
            config.baseBackgroundColor = .terbuckDarkGray10
            config.image = .selectedCheck

        case .deactivate:
            config = .bordered()
            config.baseBackgroundColor = .terbuckWhite
            config.background.strokeColor = .terbuckBlack5
            config.background.strokeWidth = 1
            config.image = .notSelectedCheck
        }

        config.imagePlacement = .all // 중앙에 이미지
        config.contentInsets = .zero

        self.configuration = config
    }
    
    func setupButtonAction() {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        buttonState.toggle()
    }
}
