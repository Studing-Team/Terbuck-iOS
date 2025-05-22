//
//  StoreCategoryCollectionVieCell.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/16/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class StoreCategoryCollectionVieCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var categoryType: CategoryType?
    
    // MARK: - UI Properties
    
    private let contentStackView = UIStackView()
    private let categoryImageView = UIImageView()
    private let categoryTitleLabel = UILabel()
    
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    public override var isSelected: Bool {
        didSet {
            updateLayout(isSelected)
        }
    }
}

// MARK: - Extensions

public extension StoreCategoryCollectionVieCell {
//    func configureCell(forCase model: CategoryType) {
//        categoryType = model
//        categoryImageView.image = model.icon
//        categoryTitleLabel.text = model.title
//    }
    func configureCell(forCase model: CategoryModel) {
        print("바뀌고 있는 셀:", model.type.title)
        self.contentStackView.backgroundColor = model.isSelected ? DesignSystem.Color.uiColor(.terbuckGreen50) : .white
        self.contentStackView.layer.cornerRadius = 17
        
        categoryImageView.image = model.type.icon
        categoryTitleLabel.text = model.type.title
        
        if categoryTitleLabel.text == "전체" {
            categoryTitleLabel.textColor = model.isSelected ? .white : DesignSystem.Color.uiColor(.terbuckBlack30)
            categoryTitleLabel.font = model.isSelected ? DesignSystem.Font.uiFont(.textSemi14) : DesignSystem.Font.uiFont(.textRegular14)
            categoryImageView.isHidden = true
            categoryTitleLabel.isHidden = false
            contentStackView.layoutMargins =  UIEdgeInsets(top: 8.5, left: 12, bottom: 8.5, right: 12)
        }
        
        if categoryTitleLabel.text != "전체" {
            categoryImageView.isHidden = false
            categoryTitleLabel.isHidden = model.isSelected ? true : false
            categoryTitleLabel.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
                
            if model.isSelected == true {
                categoryImageView.image = model.type.selectIcon
                contentStackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            } else {
                categoryImageView.image = model.type.icon
                contentStackView.layoutMargins = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            }
        }
    }
}

// MARK: - Private Extensions

private extension StoreCategoryCollectionVieCell {
    func setupStyle() {
        contentStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 2
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 8.5, left: 12, bottom: 8.5, right: 12)
            $0.addArrangedSubviews(categoryImageView, categoryTitleLabel)
        }
        
        categoryImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        
        categoryTitleLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textRegular14)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentStackView)
    }
    
    func setupLayout() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        categoryImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
    }
    
    func updateLayout(_ isSelected: Bool) {
        guard let categoryType else { return }
        
        self.backgroundColor = isSelected ? DesignSystem.Color.uiColor(.terbuckGreen50) : .white
        
        if categoryType == .all {
            categoryImageView.isHidden = true
            categoryTitleLabel.font = isSelected ? DesignSystem.Font.uiFont(.textSemi14) : DesignSystem.Font.uiFont(.textRegular14)
            categoryTitleLabel.textColor = isSelected ? .white : DesignSystem.Color.uiColor(.terbuckBlack30)
            
        } else {
            categoryTitleLabel.isHidden = isSelected ? true : false
            
            if isSelected {
                
//                contentStackView.removeArrangedSubview(categoryTitleLabel)
//                categoryTitleLabel.removeFromSuperview()
            } else {
                
//                contentStackView.insertArrangedSubview(categoryTitleLabel, at: 1)
            }
        }
        
//        if categoryTitleLabel.text == "전체" {
//            print("실행 되고 있음")
////            categoryTitleLabel.isHidden = false
//            categoryTitleLabel.font = isSelected ? DesignSystem.Font.uiFont(.textSemi14) : DesignSystem.Font.uiFont(.textRegular14)
//            categoryTitleLabel.textColor = isSelected ? .white : DesignSystem.Color.uiColor(.terbuckBlack30)
//            contentStackView.layoutMargins = UIEdgeInsets(top: 8.5, left: 12, bottom: 8.5, right: 12)
//        } else {
//            contentStackView.layoutMargins = isSelected ? UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12) : UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
//        }
        
        
        
//        if categoryTitleLabel.text == "전체" {
//            categoryTitleLabel.isHidden = false
//            categoryTitleLabel.font = isSelected ? DesignSystem.Font.uiFont(.textSemi14) : DesignSystem.Font.uiFont(.textRegular14)
//            categoryTitleLabel.textColor = isSelected ? .white : DesignSystem.Color.uiColor(.terbuckBlack30)
//            contentStackView.layoutMargins = UIEdgeInsets(top: 8.5, left: 12, bottom: 8.5, right: 12)
//        } else {
////            categoryTitleLabel.isHidden = isSelected
//            categoryTitleLabel.textColor = isSelected ? .white : DesignSystem.Color.uiColor(.terbuckBlack30)
////            categoryTitleLabel.font = DesignSystem.Font.uiFont(.textRegular14)
//
//            contentStackView.layoutMargins = isSelected
//            ? UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
//            : UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
//            
//            // 옵션: 숨길 때 width를 0으로
////            categoryTitleLabel.snp.remakeConstraints {
////                if isSelected {
////                    $0.width.equalTo(0)
////                }
////            }
//        }
    }
}
