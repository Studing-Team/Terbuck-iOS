
//
//  HomeViewController.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import UIKit
import Combine

import DesignSystem
import Shared

import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeViewModel: HomeViewModel
    weak var coordinator: HomeCoordinator?
    private var holeLocation: CGRect?
    
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let titleLogo = TerbuckLogoLabel(type: .medium)
    private let studentIDCardButton = UIButton()
    private let segmentedTabView = SegmentedTabView()
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    }()
    
    // MARK: - Init
    
    init(
        homeViewModel: HomeViewModel,
        coordinator: HomeCoordinator
    ) {
        self.homeViewModel = homeViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .terbuckWhite3
        navigationItem.backButtonTitle = ""
        
        viewLifeCycleSubject.send(.viewDidLoad)
        
        setupStyle(UserDefaultsManager.shared.bool(for: .isStudentIDAuthenticated))
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        setupCollectionView()
        setupDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 버튼의 frame을 전체 화면 기준으로 변환 (ex. window 좌표계 기준)
        holeLocation = studentIDCardButton.convert(studentIDCardButton.bounds, to: view)
    }
}

// MARK: - Private Bind Extensions

private extension HomeViewController {
    func bindViewModel() {
        let input = HomeViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher(),
            studentIDCardButtonTap: studentIDCardButton.tapPublisher.eraseToAnyPublisher()
        )
        
        let output = homeViewModel.transform(input: input)
        
        output.studentIDCardButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authResult in
                self?.setupStyle(authResult)
                
                if authResult == true {
                    self?.coordinator?.showAuthStudentID()
                } else {
                    guard let holeLocation = self?.holeLocation else { return }
                    self?.coordinator?.showOnboardiing(location: holeLocation)
                }
            }
            .store(in: &cancellables)
        
        homeViewModel.sectionDataSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapshot()
            }
            .store(in: &cancellables)
        
        
        segmentedTabView
            .selectedFilterPublisher
            .sink { [weak self] filterType in
                self?.homeViewModel.selectedFilterSubject.send(filterType)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension HomeViewController {
    func setupStyle(_ isAuth: Bool) {
        studentIDCardButton.do {
            $0.setImage(isAuth ? .authIdCard : .notAuthIdCard, for: .normal)
            $0.adjustsImageWhenHighlighted = false
        }
    }
    
    func setupHierarchy() {
        self.view.addSubviews(titleLogo, studentIDCardButton, segmentedTabView, collectionView)
    }
    
    func setupLayout() {
        titleLogo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(view.convertByHeightRatio(25))
            $0.leading.equalToSuperview().offset(25)
        }
        
        studentIDCardButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLogo)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        segmentedTabView.snp.makeConstraints {
            $0.top.equalTo(titleLogo.snp.bottom).offset(view.convertByHeightRatio(35))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedTabView.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        
    }
}

// MARK: - CollectionView Extension

private extension HomeViewController {
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        
        // Cell 등록
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.className)
        collectionView.register(PartnershipCollectionViewCell.self, forCellWithReuseIdentifier: PartnershipCollectionViewCell.className)
        
        // 커스텀 헤더 뷰 등록
        collectionView.register(CustomHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CustomHeaderCollectionReusableView.className)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            let currentSectionData = homeViewModel.sectionDataSubject.value

            
            switch self.homeViewModel.selectedFilterSubject.value {
            case .restaurent, .convenient:
                return self.createStoreSection()
                
            case .partnership:
                let hasNew = currentSectionData[.newBenefit]?.isEmpty == false
                let hasGeneral = currentSectionData[.general]?.isEmpty == false

                if hasNew && hasGeneral {
                    if sectionIndex == 0 {
                        return self.createPartnershipNewSection()
                    } else if sectionIndex == 1 {
                        return self.createPartnershipGeneralSection()
                    } else {
                        return nil
                    }
                } else if hasNew {
                    return self.createPartnershipNewSection()
                } else if hasGeneral {
                    return self.createPartnershipGeneralSection()
                } else {
                    return nil
                }
            }
        }
        
        // 배경 뷰 등록
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: "background")
        
        return layout
    }
    
    func createStoreSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 0)
        section.interGroupSpacing = 15
        
        return section
    }
    
    func createPartnershipNewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(37)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(37)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(30)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        section.interGroupSpacing = 30
        section.contentInsets = .init(top: 35, leading: 20, bottom: 20, trailing: 20)
        
        // 배경 추가
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 34, leading: 0, bottom: 0, trailing: 0)
        section.decorationItems = [backgroundDecoration]

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
    
    func createPartnershipGeneralSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(37)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(37)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 30
        section.contentInsets = .init(top: 36, leading: 20, bottom: 20, trailing: 20)
        
        // 배경 추가
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        section.decorationItems = [backgroundDecoration]

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
}

// MARK: - UICollectionViewDiffableDataSource Extensions

extension HomeViewController {
    func setupDataSource() {
        // DiffableDataSource 설정
        dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(collectionView: collectionView) {
            [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            
            switch item {
            case .restaurant(let model):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: StoreCollectionViewCell.className,
                    for: indexPath
                ) as! StoreCollectionViewCell
                
                cell.configureCell(forModel: model)
                
                cell.onMoreBenefitTapped { [weak self] in
                    self?.showStoreBenefitAlert(storeName: model.storeName, address: model.address, category: model.cateotry, benefitData: model.subBenefit ?? [])
                }
                
                return cell
                
            case .convenient(let model):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: StoreCollectionViewCell.className,
                    for: indexPath
                ) as! StoreCollectionViewCell
                
                cell.configureCell(forModel: model)
                
                cell.onMoreBenefitTapped { [weak self] in
                    self?.showStoreBenefitAlert(storeName: model.storeName, address: model.address, category: model.cateotry, benefitData: model.subBenefit ?? [])
                }
                
                return cell
                
            case .partnership(let model):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PartnershipCollectionViewCell.className,
                    for: indexPath
                ) as! PartnershipCollectionViewCell
                
                cell.configureCell(forModel: model)
                return cell
            }
        }
        
        // 헤더 뷰 설정
        configureSupplementaryViews()
        
        // 초기 스냅샷 적용
        applySnapshot()
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        
        switch homeViewModel.selectedFilterSubject.value {
        case .restaurent:
            guard let items = homeViewModel.sectionDataSubject.value[.restaurant] else { return }
            
            snapshot.appendSections([.restaurant])
            snapshot.appendItems(items, toSection: .restaurant)
            
        case .convenient:
            guard let items = homeViewModel.sectionDataSubject.value[.convenient] else { return }
            
            snapshot.appendSections([.convenient])
            snapshot.appendItems(items, toSection: .convenient)
            
        case .partnership:
            if let items = homeViewModel.sectionDataSubject.value[.newBenefit] {
                snapshot.appendSections([.newBenefit])
                snapshot.appendItems(items, toSection: .newBenefit)
            }
            
            if let items = homeViewModel.sectionDataSubject.value[.general] {
                snapshot.appendSections([.general])
                snapshot.appendItems(items, toSection: .general)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureSupplementaryViews() {
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self,
                  kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            // 현재 섹션이 newBenefit 일 때만 헤더 생성
            let sectionIdentifiers = self.dataSource.snapshot().sectionIdentifiers
            if indexPath.section < sectionIdentifiers.count {
                let section = sectionIdentifiers[indexPath.section]
                switch section {
                case .newBenefit:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: CustomHeaderCollectionReusableView.className,
                        for: indexPath
                    ) as! CustomHeaderCollectionReusableView

                    return headerView

                default:
                    return nil
                }
            }
            
            return nil
        }
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("HomeViewController") {
//    HomeViewController()
//        .showPreview()
//}
//#endif
