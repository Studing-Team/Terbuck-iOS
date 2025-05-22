//
//  StoreListModalViewController.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/13/25.
//

import UIKit
import Combine

import DesignSystem
import Shared

import SnapKit
import Then

public enum StoreListType {
    case horizonList
    case verticalList
}

public final class StoreListModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, StoreListModel.ID>?
    private var cateoryDataSource: UICollectionViewDiffableDataSource<Int, CategoryModel>?
    private let storeMapViewModel: StoreMapViewModel
    
    private var selectedIndexPath: IndexPath? = IndexPath(index: 1)
    
    weak var coordinator: StoreCoordinator?
    
    
    private var panGesture: UIPanGestureRecognizer!
    private var sheetTopConstraint: Constraint?
    private var currentSnapIndex = 1
    private let snapPoints: [CGFloat] = [180, 290, 454, 700]
    
    weak var delegate: StoreBottomSheetDelegate?
    
    public var initialSnapPoint: CGFloat {
       snapPoints.isEmpty ? 290 : snapPoints[currentSnapIndex]
   }
    
    private var type: StoreListType
    
    private var storeCollectionViewTopConstraint: Constraint?
    private var bottomConstraint: Constraint?
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    private let didSelectItemSubject = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let contentView = UIView()
    private let indicator = UIView()
    private let backgroundView = UIView()
    
    private let storeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: 375, height: 112)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 65, height: 34)
        $0.collectionViewLayout = layout
        $0.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.allowsMultipleSelection = false
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        $0.layer.shadowOffset = CGSize(width: 3, height: 3)  // 그림자 위치
        $0.layer.shadowOpacity = 0.3  // 그림자 투명도
        $0.layer.shadowRadius = 5 // 그림자 퍼짐 정도
    }
    
    // MARK: - Init
    
    public init(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator,
        type: StoreListType
    ) {
        self.storeMapViewModel = storeMapViewModel
        self.coordinator = coordinator
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("deinit StoreListModalViewController")
        #endif
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupStoreDataSource()
        bindViewModel()
        setupGesture()
        setupCategoryDataSource()
        setupCollectionView()
        
        delegate?.bottomSheet(self, currentPoint: snapPoints[currentSnapIndex], didChangeHeight: 0)
    }
    
    public func changeBottomSheet(_ type: StoreListType)  {
        switch type {
        case .horizonList:
            indicator.isHidden = true
            storeCollectionViewTopConstraint?.deactivate()
            storeCollectionView.snp.makeConstraints {
                storeCollectionViewTopConstraint = $0.top.equalToSuperview().offset(0).constraint
                $0.height.equalTo(112)
            }
            bottomConstraint?.deactivate()
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 325, height: 112)
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            
            storeCollectionView.setCollectionViewLayout(layout, animated: true)
            storeCollectionView.showsHorizontalScrollIndicator = false
            storeCollectionView.isScrollEnabled = true
            storeCollectionView.isPagingEnabled = true
            
            containerView.removeGestureRecognizer(panGesture)
            
            // 배경색 없애기
            contentView.backgroundColor = .clear
            
            delegate?.bottomSheet(self, currentPoint: 270, didChangeHeight: 0)
            
        case .verticalList:
            print("수직 레이아웃으로 다시 설정")
            indicator.isHidden = false
            storeCollectionViewTopConstraint?.deactivate()
            storeCollectionView.snp.makeConstraints {
                storeCollectionViewTopConstraint = $0.top.equalTo(indicator.snp.bottom).offset(15).constraint
            }
            bottomConstraint?.activate()
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 375, height: 112)
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

            storeCollectionView.setCollectionViewLayout(layout, animated: true)
            storeCollectionView.isScrollEnabled = false
            storeCollectionView.isPagingEnabled = false
            setupGesture()
            // 배경색 복원
            contentView.backgroundColor = .white
            
            delegate?.bottomSheet(self, currentPoint: snapPoints[currentSnapIndex], didChangeHeight: 0)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let sheetHeight = view.frame.height - 46 //getTabBarHeight()
        let threshold: CGFloat = 40 // 제스처 이동 임계값
        
        print("현재 위치: \(currentSnapIndex), Y 이동량: \(translation.y)")
        print("시트 전체 높이:" , sheetHeight + translation.y)
        
        switch gesture.state {
        case .changed:
            
            storeCollectionView.isScrollEnabled = false
            
            if translation.y < 0 && currentSnapIndex != 3 { // 위로 스크롤
                delegate?.bottomSheet(self, currentPoint: snapPoints[currentSnapIndex], didChangeHeight: -translation.y)

            } else if translation.y > 0 && currentSnapIndex != 0 {
                delegate?.bottomSheet(self, currentPoint: snapPoints[currentSnapIndex], didChangeHeight: -translation.y)
            }
            
        case .ended, .cancelled:
            var newSnapIndex = currentSnapIndex

            // 위로 스와이프 (translation.y < 0)
            if translation.y < 0 && -translation.y > threshold && currentSnapIndex != 3 {
                newSnapIndex = currentSnapIndex + 1
                          
                storeCollectionView.isScrollEnabled = newSnapIndex == 3 ? true : false
            }
            
            // 아래로 스와이프 (translation.y > 0)
            else if translation.y > 0 && translation.y > threshold && currentSnapIndex != 0 {
                newSnapIndex = currentSnapIndex - 1
            }

            currentSnapIndex = newSnapIndex

            delegate?.bottomSheet(self, currentPoint: snapPoints[currentSnapIndex], didChangeHeight: 0)
        
        default:
            break
        }
    }
}

// MARK: - Private Bind Extensions

private extension StoreListModalViewController {
    func bindViewModel() {
        let input = StoreMapViewModel.Input(
             viewLifeCycleEventAction: Empty().eraseToAnyPublisher()
        )
        
        let output = storeMapViewModel.transform(input: input)
        
        output.storeListData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                print("💡 store list count: \(items.count)")
                self?.applyStoreSnapshot(items: items)
            }
            .store(in: &cancellables)
        
        output.categoryData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applyCategorySnapshot(items: items)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension StoreListModalViewController {
    func setupGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        containerView.addGestureRecognizer(panGesture)
    }
    
    func setupStyle() {
        self.view.backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
            $0.layer.shadowOffset = CGSize(width: 3, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 0.3  // 그림자 투명도
            $0.layer.shadowRadius = 5 // 그림자 퍼짐 정도
        }
        
        containerView.do {
            $0.backgroundColor = .clear
        }
        
        indicator.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckBlack5)
            $0.layer.cornerRadius = 2
        }
        
        storeCollectionView.do {
            $0.backgroundColor = .clear
        }
        
        backgroundView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckDarkGray10)
            $0.layer.masksToBounds = false
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(1.0).cgColor
            $0.layer.shadowOffset = CGSize(width: 1, height: -50) // 하단 그림자
            $0.layer.shadowOpacity = 1.0 // 부드러운 투명도
            $0.layer.shadowRadius = 32 // 퍼짐 정도
        }
    }
    
    func setupHierarchy() {
        view.addSubview(containerView)
        containerView.addSubviews(contentView, categoryCollectionView)//, backgroundView)
        contentView.addSubviews(indicator, storeCollectionView)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        indicator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(4)
        }
        
        storeCollectionView.snp.makeConstraints {
            storeCollectionViewTopConstraint = $0.top.equalTo(indicator.snp.bottom).offset(15).constraint
            $0.horizontalEdges.equalToSuperview()
            bottomConstraint = $0.bottom.equalToSuperview().constraint
        }
    }
    
    func setupCollectionView() {
        categoryCollectionView.register(StoreCategoryCollectionVieCell.self, forCellWithReuseIdentifier: StoreCategoryCollectionVieCell.className)
        
        storeCollectionView.register(StoreListModelCollectionViewCell.self, forCellWithReuseIdentifier: StoreListModelCollectionViewCell.className)
    }
    
    func setupDelegate() {
        storeCollectionView.delegate = self

        categoryCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDelegate

extension StoreListModalViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == storeCollectionView {

            print("storeCollectionView 눌림:", indexPath.row)
            storeMapViewModel.didSelectItemSubject.send(indexPath.row)
            
        } else if collectionView == self.categoryCollectionView {
            // 일반 collectionView 관련 처리
            print("categoryCollectionView 눌림:", indexPath.row)
            
            var category = storeMapViewModel.storeCategoryPublisher.value
            
            guard let index = category.firstIndex(where: { $0.isSelected == true }) else { return }
            
            category[index].isSelected = false
            category[indexPath.row].isSelected = true
            
            storeMapViewModel.storeCategoryPublisher.send(category)
        }
    }
}

// MARK: - UICollectionViewDiffableDataSource Extensions

extension StoreListModalViewController {
    func setupStoreDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, StoreListModel.ID>(collectionView: storeCollectionView) { [weak self] collectionView, indexPath, itemId in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreListModelCollectionViewCell.className, for: indexPath) as! StoreListModelCollectionViewCell
            
            let item = self?.storeMapViewModel.item(forId: itemId)
            
            cell.configureCell(forModel: item ?? StoreListModel(image: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!, storeName: "터벅터벅 공릉점", storeAddress: "서울 노원구 동이로190길 49 지층", category: .restaurant, benefitCount: 2, latitude: 37.52015323931828, longitude: 126.67337768520443))
            return cell
        }
    }
    
    func applyStoreSnapshot(items: [StoreListModel], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, StoreListModel.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(items.map { $0.id })
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - CollectionView Extension

extension StoreListModalViewController {
    func setupCategoryDataSource() {
        cateoryDataSource = UICollectionViewDiffableDataSource<Int, CategoryModel>(collectionView: categoryCollectionView) { [weak self] collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCategoryCollectionVieCell.className, for: indexPath) as! StoreCategoryCollectionVieCell
            
            cell.configureCell(forCase: item) // 필요한 데이터 전달
            return cell
        }
    }
    
    func applyCategorySnapshot(items: [CategoryModel], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CategoryModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        cateoryDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("StoreListModalViewController") {
//    StoreListModalViewController()
//        .showPreview()
//}
//#endif
