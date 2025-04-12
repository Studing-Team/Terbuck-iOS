//
//  LoginViewController.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

public final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties
    
    private let terbuckTitleLabel = UILabel()
    private let terbuckLogoLabel = TerbuckLogoLabel(type: .max)
    private let appleLoginButton = SocialLoginButton(type: .apple)
    private let kakaoLoginButton = SocialLoginButton(type: .kakao)
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
}

// MARK: - Private Extensions

private extension LoginViewController {
    func setupStyle() {
        terbuckTitleLabel.do {
            $0.text = "한 걸음마다 있는 우리 학교 제휴 혜택"
            $0.font = .textRegular16
            $0.textColor = .terbuckDarkGray50
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(terbuckTitleLabel, terbuckLogoLabel, kakaoLoginButton, appleLoginButton)
    }
    
    func setupLayout() {
        terbuckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(194))
            $0.horizontalEdges.equalToSuperview().inset(71)
        }
        
        terbuckLogoLabel.snp.makeConstraints {
            $0.top.equalTo(terbuckTitleLabel.snp.bottom).offset(view.convertByHeightRatio(6))
            $0.horizontalEdges.equalToSuperview().inset(70)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(terbuckLogoLabel.snp.bottom).offset(view.convertByHeightRatio(190))
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(45)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(view.convertByHeightRatio(12))
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(45)
        }
    }
    
    func setupDelegate() {
        
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("LoginViewController") {
    LoginViewController()
        .showPreview()
}
#endif
