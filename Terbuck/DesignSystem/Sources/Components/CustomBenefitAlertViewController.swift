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
    private let benefitData: [StoreBenefitsModel]
    
    // MARK: - UI Properties
    
    private let alertBackgroundView = UIView()
    private let storeInfoTitleView = StoreInfoTitleView()
    private let moreBeneiftStackView = UIStackView()
    private let bottomButton = TerbuckBottomButton(type: .close(type: .nomal))
    
    private let benefitCollectionView: UICollectionView = {
        let sideInset: CGFloat = 20
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - (sideInset * 2), height: 53)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = layout
        return collectionView
    }()
    
    // MARK: - Init
    
    public init(
        name: String,
        address: String,
        category: CategoryType,
        benefitData: [StoreBenefitsModel]
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
        AppLogger.log("CustomBenefitAlertViewController Deinit", .info, .ui)
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        AppLogger.log("CustomBenefitAlertViewController ViewDidLoad", .info, .ui)
        
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
        self.view.addSubviews(alertBackgroundView, bottomButton)
        alertBackgroundView.addSubviews(storeInfoTitleView, moreBeneiftStackView)
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
            $0.bottom.equalToSuperview().inset(13)
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(alertBackgroundView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
    }
    
    func setupDelegate() {
        
    }
    
    func configureData(benefitData: [StoreBenefitsModel]) {
        benefitData.forEach {
            let benefitStackView = createBenefitList(benefits: $0)
            moreBeneiftStackView.addArrangedSubview(benefitStackView)
        }
        
        storeInfoTitleView.configureData(name: self.name, address: self.address, category: self.category)
    }
    
    func createBenefitList(benefits: StoreBenefitsModel) -> UIStackView {
        
//        let stackView = benefitStackView(mainBeneiftTitle: benefits.title, subBeneiftTitle: benefits.details)
        
        
        
//        let mainStackView = UIStackView()
//        mainStackView.axis = .vertical
//        mainStackView.spacing = 4
//        mainStackView.alignment = .top
//        mainStackView.addArrangedSubviews(subStackView)
        
        
        
        
//        let checkedImageView = UIImageView(image: .checked)
//        checkedImageView.contentMode = .scaleAspectFit
////        
//        let benefitLabel = UILabel()
//        benefitLabel.text = benefits
//        benefitLabel.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
//        benefitLabel.font = DesignSystem.Font.uiFont(.textRegular16)
//        benefitLabel.numberOfLines = 2
////
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 4
//        stackView.alignment = .top
//        stackView.addArrangedSubviews(checkedImageView, benefitLabel)
        
        return benefitStackView(mainBeneiftTitle: benefits.title, subBeneiftTitle: benefits.details)
    }
    
    func benefitStackView(mainBeneiftTitle: String, subBeneiftTitle: [String]) -> UIStackView {

        let benefitLabel = UILabel()
        benefitLabel.text = mainBeneiftTitle
        benefitLabel.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
        benefitLabel.font = DesignSystem.Font.uiFont(.textRegular16)
        
        let subBenefitStackView = subBenefitTitle(subBeneiftTitle: subBeneiftTitle)
        
        let subStackView = UIStackView()
        subStackView.axis = .vertical
        subStackView.spacing = 10
        subStackView.addArrangedSubviews(benefitLabel, subBenefitStackView)

        return subStackView
    }
    
    func subBenefitTitle(subBeneiftTitle: [String]) -> UIStackView {
        let subBenefitStackView = UIStackView()
        subBenefitStackView.axis = .vertical
        subBenefitStackView.spacing = 10
        
        subBeneiftTitle.forEach {
            let benefitLabel = UILabel()
            benefitLabel.text = "∙ \($0)"
            benefitLabel.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
            benefitLabel.font = DesignSystem.Font.uiFont(.textRegular16)
            benefitLabel.numberOfLines = 2
            
            subBenefitStackView.addArrangedSubviews(benefitLabel)
        }
        
        return subBenefitStackView
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
                                     benefitData: [StoreBenefitsModel(title: "1:1 PT 할인", details: ["PT 10회 + 헬스 3개월 = 40만원", "PT 20회 + 헬스 4개월 = 90만원"]),
                                                   StoreBenefitsModel(title: "1:1 PT 할인", details: ["PT 10회 + 헬스 3개월 = 40만원", "PT 20회 + 헬스 4개월 = 90만원"])
                                                  ])
//                                     benefitData: ["18시 이전 방문 고객 소주 1병 제공", "25,000원 이상 주문 시, 빙수 또는 감자튀김 제공", "메이게츠에서의 영수증(결제일로부터 최대 3일) 보여줄 시 꼬치네에서 소주 1병 제공", "소주 볼링핀(10병) 인스타그램 스토리 총학과 꼬치네 계정 태그와 함께 업로드 시 치즈스틱 제공"])
        .showPreview()
}
#endif
