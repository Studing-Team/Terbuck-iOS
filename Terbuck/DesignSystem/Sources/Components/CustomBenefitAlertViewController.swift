//
//  CustomBenefitAlertViewController.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit

import Shared

import SnapKit
import Then

public final class CustomBenefitAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    private let name: String
    private let address: String
    private let category: CategoryType
    private let benefitData: [String]
    
    // MARK: - UI Properties
    
    private let alertBackgroundView = UIView()
    private let storeInfoTitleView = StoreInfoTitleView()
    private let moreBeneiftStackView = UIStackView()
    private let bottomButton = TerbuckBottomButton(type: .close(type: .nomal))
    
    // MARK: - Init
    
    public init(
        name: String,
        address: String,
        category: CategoryType,
        benefitData: [String]
    ) {
        self.name = name
        self.address = address
        self.category = category
        self.benefitData = benefitData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("deinit CustomBenefitAlertViewController")
        #endif
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystem.Color.uiColor(.terbuckAlertBackground)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelBackgroundAction)))
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupButtonActions()
        configureData(benefitData: self.benefitData)
    }
}

// MARK: - Private Extensions

private extension CustomBenefitAlertViewController {
    func setupStyle() {
        alertBackgroundView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
            $0.layer.cornerRadius = 24
        }
        
        moreBeneiftStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .top
        }
    }
    
    func setupHierarchy() {
        self.view.addSubviews(alertBackgroundView)
        alertBackgroundView.addSubviews(storeInfoTitleView, moreBeneiftStackView, bottomButton)
    }
    
    func setupLayout() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        storeInfoTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        moreBeneiftStackView.snp.makeConstraints {
            $0.top.equalTo(storeInfoTitleView.snp.bottom).offset(39)
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(moreBeneiftStackView.snp.bottom).offset(42)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(13)
        }
    }
    
    func setupDelegate() {
        
    }
    
    func configureData(benefitData: [String]) {
        benefitData.forEach {
            let benefitStackView = createBenefitList(benefits: $0)
            moreBeneiftStackView.addArrangedSubview(benefitStackView)
        }
        
        storeInfoTitleView.configureData(name: self.name, address: self.address, category: self.category)
    }
    
    func createBenefitList(benefits: String) -> UIStackView {
        let checkedImageView = UIImageView(image: .checked)
        checkedImageView.contentMode = .scaleAspectFit
        
        let benefitLabel = UILabel()
        benefitLabel.text = benefits
        benefitLabel.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        benefitLabel.font = DesignSystem.Font.uiFont(.textRegular14)
        benefitLabel.numberOfLines = 2
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .top
        stackView.addArrangedSubviews(checkedImageView, benefitLabel)
        
        return stackView
    }
    
    func setupButtonActions() {
        bottomButton.buttonAction = { [weak self] in
            self?.dismiss(animated: false)
        }
    }
    
    @objc func cancelBackgroundAction() {
        dismiss(animated: false)
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("CustomBenefitAlertViewController") {
    CustomBenefitAlertViewController(name: "터벅터벅 공릉점",
                                     address: "서울 노원구 동일로190길 49 지층",
                                     category: .restaurant,
                                     benefitData: ["18시 이전 방문 고객 소주 1병 제공", "25,000원 이상 주문 시, 빙수 또는 감자튀김 제공", "메이게츠에서의 영수증(결제일로부터 최대 3일) 보여줄 시 꼬치네에서 소주 1병 제공", "소주 볼링핀(10병) 인스타그램 스토리 총학과 꼬치네 계정 태그와 함께 업로드 시 치즈스틱 제공"])
        .showPreview()
}
#endif
