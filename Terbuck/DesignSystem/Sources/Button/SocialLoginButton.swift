//
//  SocialLoginButton.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit

import Resource

import SnapKit
import Then

public final class SocialLoginButton: UIButton {

    // MARK: - Properties
    
    public enum SocialButtonType {
        case apple
        case kakao
        
        var title: String {
            switch self {
            case .apple: return "Apple로 계속하기"
            case .kakao: return "카카오로 계속하기"
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .apple: return DesignSystem.Color.uiColor(.terbuckWhite)
            case .kakao: return UIColor(red: 254/255, green: 229/255, blue: 0/255, alpha: 1)
            }
        }

        var logoImage: UIImage? {
            switch self {
            case .apple: return .appleLogo
            case .kakao: return .kakaoLogo
            }
        }

        var hasBorder: Bool {
            return self == .apple
        }
    }
    
    // MARK: - UI Properties
    
    private let logoImageView = UIImageView()
    private let titleLabelView = UILabel()

    // MARK: - Init
    
    public init(type: SocialButtonType) {
        super.init(frame: .zero)
        setupStyle(type: type)
        setupHierarchy()
        setupLayout(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension SocialLoginButton {
    func setupStyle(type: SocialButtonType) {
        if type.hasBorder {
            self.layer.borderColor =  DesignSystem.Color.uiColor(.terbuckBlack50).cgColor
            self.layer.borderWidth = 0.5
        }
        
        self.backgroundColor = type.backgroundColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        logoImageView.do {
            $0.image = type.logoImage
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabelView.do {
            $0.text = type.title
            $0.font = DesignSystem.Font.uiFont(.textRegular14)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(logoImageView, titleLabelView)
    }
    
    func setupLayout(type: SocialButtonType) {
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
            $0.size.equalTo(type == .kakao ? 18 : 20)
        }
        
        titleLabelView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
