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
    
    public enum AuthCheckType {
        case notBorder
        case nomal
    }
    
    // MARK: - Properties
    
    private var buttonState: ButtonState {
        didSet {
            updateButtonState()
        }
    }
    
    private var type: AuthCheckType
    
    // MARK: - Init
    
    public init(
        type: AuthCheckType = .nomal,
        buttonState: ButtonState = .deactivate
    ) {
        self.type = type
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
    
    public func changeButtonState(isSelect: Bool) {
        self.buttonState = isSelect == true ? .activate: .deactivate
    }
}

// MARK: - Private Extensions

private extension AuthCheckButton {
    func setupButton() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 11
        self.clipsToBounds = true
        
        self.snp.makeConstraints {
            $0.size.equalTo(22)
        }
    }
    
    func updateButtonState() {
        self.configuration = nil
        
        var config: UIButton.Configuration

        switch buttonState {
        case .activate:
            config = .filled()
            config.baseBackgroundColor = DesignSystem.Color.uiColor(.terbuckDarkGray10)
            config.image = .selectedCheck
            self.layer.borderWidth = 0
            
        case .deactivate:
            config = .bordered()
            config.baseBackgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
            config.image = .notSelectedCheck

            if type == .nomal {
                self.layer.borderWidth = 1
                self.layer.borderColor = DesignSystem.Color.uiColor(.terbuckBlack5).cgColor
            }
        }

        config.imagePlacement = .all
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
