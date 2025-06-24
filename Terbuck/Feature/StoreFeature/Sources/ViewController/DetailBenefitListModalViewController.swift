//
//  DetailBenefitListModalViewController.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 6/23/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

protocol BottomSheetDelegate: AnyObject {
    func didRequestDismissBottomSheet()
}

final class DetailBenefitListModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private var currentContentHeight: CGFloat = 360
    private let maxHeight: CGFloat = 560
    private let cellHeight: CGFloat = 53
    private let cellSpacing: CGFloat = 8
    private var dataSources = [String]()
    
    private var panGesture: UIPanGestureRecognizer!
    weak var delegate: BottomSheetDelegate?
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let contentView = UIView()
    private let indicator = UIView()
    
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
        moreBenefitListData: [String]
    ) {
        self.dataSources = moreBenefitListData
        super.init(nibName: nil, bundle: nil)
        
        self.calculateContentHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupCollectionView()
        setupDelegate()
        setupGesture()
    }
}

// MARK: - Private Extensions

private extension DetailBenefitListModalViewController {
    func setupStyle() {
        self.view.backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .clear
        }
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: -5)
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowRadius = 20
        }
        
        indicator.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckBlack5)
            $0.layer.cornerRadius = 2
        }
    }
    
    func setupHierarchy() {
        view.addSubview(containerView)
        containerView.addSubviews(contentView)
        contentView.addSubviews(indicator, benefitCollectionView)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(currentContentHeight)
        }
        
        indicator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(4)
        }
        
        benefitCollectionView.snp.makeConstraints {
            $0.top.equalTo(indicator.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        benefitCollectionView.dataSource = self
    }
    
    func setupCollectionView() {
        benefitCollectionView.register(MoreBenefitListCollectionViewCell.self, forCellWithReuseIdentifier: MoreBenefitListCollectionViewCell.className)
    }
    
    func setupGesture() {
        // Drag gesture → contentView (기존과 동일)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        contentView.addGestureRecognizer(panGesture)
        
        // Tap gesture → containerView (배경 클릭 시 dismiss)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        containerView.addGestureRecognizer(tapGesture)
        
        // containerView → contentView 로 전달 방지 (필수)
        tapGesture.cancelsTouchesInView = false
    }
    
    func calculateContentHeight() {
        let count = dataSources.count
        let contentHeight = (Int(cellHeight) * count) + Int(cellSpacing) * (count-1)
        let calculateContentHeight = CGFloat(contentHeight + 30 + 50)

        currentContentHeight = calculateContentHeight >= maxHeight ? maxHeight : calculateContentHeight
    }
    
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        // 터치한 위치가 contentView 영역 바깥이면 dismiss
        let location = gesture.location(in: containerView)
        
        if !contentView.frame.contains(location) {
            delegate?.didRequestDismissBottomSheet()
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let standardContentHeight = currentContentHeight
        print(translation.y)
        switch gesture.state {
        case .changed:
            
            print(standardContentHeight - translation.y)
            contentView.snp.remakeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(standardContentHeight - translation.y)
            }
            
        case .ended, .cancelled:
            if translation.y > 70 {
                delegate?.didRequestDismissBottomSheet()
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    self.contentView.snp.remakeConstraints {
                        $0.horizontalEdges.equalToSuperview()
                        $0.bottom.equalToSuperview()
                        $0.height.equalTo(standardContentHeight)
                    }
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        default:
            break
        }
    }
}

// MARK: - UICollectionView Data Sources Extensions

extension DetailBenefitListModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreBenefitListCollectionViewCell.className, for: indexPath) as! MoreBenefitListCollectionViewCell
        
        cell.configureCell(dataSources[indexPath.row])
        
        return cell
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("DetailBenefitListModalViewController") {
//    DetailBenefitListModalViewController()
//        .showPreview()
//}
//#endif
