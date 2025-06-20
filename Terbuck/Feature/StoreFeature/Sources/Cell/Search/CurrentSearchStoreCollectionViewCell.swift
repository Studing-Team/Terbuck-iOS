//
//  CurrentSearchStoreCollectionViewCell.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/21/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class CurrentSearchStoreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var deleteButtonHandler: ((CurrentSearchModel) -> Void)?
    private var serachStoreData: CurrentSearchModel?
    
    // MARK: - UI Properties

    private let currentStoreNameLabel = UILabel()
    private let deleteButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

public extension CurrentSearchStoreCollectionViewCell {
    func configureCell(_ serachData: CurrentSearchModel) {
        serachStoreData = serachData
        currentStoreNameLabel.text = serachData.storeName
    }
    
    func configureButtonAction(action: @escaping (CurrentSearchModel) -> Void) {
        deleteButtonHandler = action
    }
}

// MARK: - Private Extensions

private extension CurrentSearchStoreCollectionViewCell {
    func setupStyle() {
        currentStoreNameLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textRegular16)
            $0.textColor =  DesignSystem.Color.uiColor(.terbuckBlack50)
        }
        
        deleteButton.do {
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
            let image = UIImage(systemName: "xmark", withConfiguration: config)
            $0.setImage(image, for: .normal)
            $0.tintColor = DesignSystem.Color.uiColor(.terbuckBlack10)
            $0.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(currentStoreNameLabel, deleteButton)
    }
    
    func setupLayout() {
        currentStoreNameLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalTo(deleteButton.snp.leading).inset(15)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(currentStoreNameLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
    
    @objc
    func deleteButtonAction() {
        guard let serachStoreData else { return }
        deleteButtonHandler?(serachStoreData)
    }
}

