//
//  UniversityInfoViewController.swift
//  Login
//
//  Created by ParkJunHyuk on 4/12/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

final class UniversityInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties
    
    private let titleView = AuthTitleView(type: .university)
    
    private let universityListStackView = UIStackView()
    private let kwUniversityView = UniversityListView(type: .kw)
    private let ssUniversityView = UniversityListView(type: .ss)
    
    private let terbuckBottomButton = TerbuckBottomButton(type: .enter, isEnabled: false)
    
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

private extension UniversityInfoViewController {
    func setupStyle() {
        universityListStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.addArrangedSubviews(kwUniversityView, ssUniversityView)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(titleView, universityListStackView, terbuckBottomButton)
    }
    
    func setupLayout() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(view.convertByHeightRatio(50))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        universityListStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(view.convertByHeightRatio(192))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        terbuckBottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(12))
        }
        
        [kwUniversityView, ssUniversityView].forEach {
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

#Preview("UniversityInfoViewController") {
    UniversityInfoViewController()
        .showPreview()
}
#endif
