//
//  TermsOfServiceViewController.swift
//  Login
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

final class TermsOfServiceViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties
    
    private let titleView = AuthTitleView(type: .termsView)
    
    private let termsStackView = UIStackView()
    private let serviceTermsView = TermsListView(type: .service)
    private let userInfoTermsView = TermsListView(type: .userInfo)
    private let marketingTermsView = TermsListView(type: .marketing)
    
    private let allTermsStackView = UIStackView()
    private let allTermsCheckButton = AuthCheckButton()
    private let allTermsTitleLabel = UILabel()
    
    private let terbuckBottomButton = TerbuckBottomButton(type: .next)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .terbuckWhite
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
}

// MARK: - Private Extensions

private extension TermsOfServiceViewController {
    func setupStyle() {
        allTermsTitleLabel.do {
            $0.text = "선택약관 모두 동의하기"
            $0.font = .textSemi16
            $0.textColor = .terbuckBlack50
        }
        
        allTermsStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.addArrangedSubviews(allTermsCheckButton, allTermsTitleLabel)
            $0.backgroundColor = .terbuckWhite5
            $0.layer.cornerRadius = 8
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 15.17, left: 18.17, bottom: 15.17, right: 18.17)
        }
        
        termsStackView.do {
            $0.axis = .vertical
            $0.spacing = 2
            $0.addArrangedSubviews(serviceTermsView, userInfoTermsView, marketingTermsView)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(titleView, allTermsStackView, termsStackView, terbuckBottomButton)
    }
    
    func setupLayout() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(view.convertByHeightRatio(50))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        allTermsStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        termsStackView.snp.makeConstraints {
            $0.top.equalTo(allTermsStackView.snp.bottom).offset(view.convertByHeightRatio(8))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        terbuckBottomButton.snp.makeConstraints {
            $0.top.equalTo(termsStackView.snp.bottom).offset(view.convertByHeightRatio(40))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(12))
        }
        
        [allTermsStackView, serviceTermsView, userInfoTermsView, marketingTermsView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(52)
            }
        }
    }
    
    func setupDelegate() {
        
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("TermsOfServiceViewController") {
    TermsOfServiceViewController()
        .showPreview()
}
#endif
