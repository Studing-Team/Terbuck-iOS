//
//  BannerCollectionViewCell.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 10/25/25.
//

import UIKit
import DesignSystem

import SnapKit
import Then

final class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var bannerItem: BannerItemModel?
    
    // MARK: - UI Properties
    
    private let bannerImageView = AsyncImageView()
    
    
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
    
    // MARK: - Public Methods
    
    func configure(with item: BannerItemModel) {
        self.bannerItem = item
        bannerImageView.setImage(item.imageUrl, type: .bannerImage)
    }
}

// MARK: - Private Extensions

private extension BannerCollectionViewCell {
    func setupStyle() {
        bannerImageView.do {
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
    }
    
    func setupHierarchy() {
        contentView.addSubview(bannerImageView)
    }
    
    func setupLayout() {
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
