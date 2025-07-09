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
    
    private enum Section {
        case main
    }
    
    private let name: String
    private let address: String
    private let category: CategoryType
    private let benefitData: [StoreBenefitsModel]
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, StoreBenefitsModel>!
    
    // MARK: - UI Properties
    
    private let alertBackgroundView = UIView()
    private let storeInfoTitleView = StoreInfoTitleView()
    private let bottomButton = TerbuckBottomButton(type: .close(type: .nomal))
    private lazy var benefitCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: createLayout())
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
        setupDataSource()
        configureData(benefitData: self.benefitData)
    }
}

// MARK: - Private UICollectionView Extensions

private extension CustomBenefitAlertViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
       return UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
           let itemSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .estimated(20) // 동적 높이
           )
           let item = NSCollectionLayoutItem(layoutSize: itemSize)

           let groupSize = NSCollectionLayoutSize(
               widthDimension: .absolute(262), // 최대 너비
               heightDimension: .estimated(60)
           )
           let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

           let section = NSCollectionLayoutSection(group: group)
           section.interGroupSpacing = 15
           section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
           return section
       }
   }
    
    func setupDataSource() {
        benefitCollectionView.register(BenefitListCollectionViewCell.self, forCellWithReuseIdentifier: BenefitListCollectionViewCell.className)

        dataSource = UICollectionViewDiffableDataSource<Section, StoreBenefitsModel>(
            collectionView: benefitCollectionView
        ) { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BenefitListCollectionViewCell.className, for: indexPath) as? BenefitListCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(with: model)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, StoreBenefitsModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(benefitData, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Private Extensions

private extension CustomBenefitAlertViewController {
    func setupStyle() {
        alertBackgroundView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
            $0.layer.cornerRadius = 24
        }
    }
    
    func setupHierarchy() {
        self.view.addSubviews(alertBackgroundView, bottomButton)
        alertBackgroundView.addSubviews(storeInfoTitleView, benefitCollectionView)
    }
    
    func setupLayout() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(296)
        }
        
        storeInfoTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        benefitCollectionView.snp.makeConstraints {
            $0.top.equalTo(storeInfoTitleView.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview().inset(12)
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
        storeInfoTitleView.configureData(name: self.name, address: self.address, category: self.category)
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
        .showPreview()
}
#endif
