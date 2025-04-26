
//
//  MypageViewController.swift
//  MypageFeauture
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit
import Combine

import DesignSystem

import SnapKit
import Then

public final class MypageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mypageViewModel: MypageViewModel
    weak var coordinator: MypageCoordinator?
    
    // MARK: - Combine Publishers Properties
    
    private let selectedCellSubject = PassthroughSubject<(section: MyPageType, index: Int), Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let versionLabel = UILabel()
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    }()
    
    // MARK: - Init
    
    public init(
        mypageViewModel: MypageViewModel,
        coordinator: MypageCoordinator
    ) {
        self.mypageViewModel = mypageViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .terbuckWhite3
        navigationItem.backButtonTitle = ""
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupCollectionView()
        bindViewModel()
    }
}

// MARK: - Private Bind Extensions

private extension MypageViewController {
    func bindViewModel() {
        let input = MypageViewModel.Input(
            selectedCell: selectedCellSubject.eraseToAnyPublisher()
        )
        
        let output = mypageViewModel.transform(input: input)
        
        output.navigationEvent
            .sink { [weak self] event in
                switch event {
                case .alarmSetting:
                    self?.coordinator?.startAlarmSetting()
                case .showLogout:
                    self?.showConfirmCancelAlert(
                        mainTitle: "로그아웃 하시겠습니까?",
                        leftButton: TerbuckBottomButton(type: .cancel),
                        rightButton: TerbuckBottomButton(type: .logout),
                        rightButtonHandler: {}
                    )
                case .withdraw:
                    self?.showConfirmCancelAlert(
                        mainTitle: "정말 탈퇴하시겠습니까?",
                        subTitle: "탈퇴 회원의 정보는 완전히 삭제되며\n터벅을 떠나면 회원가입부터 다시 해야해요",
                        leftButton: TerbuckBottomButton(type: .cancel),
                        rightButton: TerbuckBottomButton(type: .draw),
                        rightButtonHandler: {}
                    )
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension MypageViewController {
    func setupStyle() {
        collectionView.backgroundColor = .clear
        
        titleLabel.do {
            $0.text = "마이페이지"
            $0.textColor = .terbuckBlack50
            $0.font = .titleSemi20
        }
        
        versionLabel.do {
            $0.text = "앱 버전  V.1.0.0"
            $0.textColor = .terbuckBlack10
            $0.font = .textRegular14
        }
    }
    
    func setupHierarchy() {
        self.view.addSubviews(titleLabel, collectionView, versionLabel)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(20))
        }
    }
    
    func setupDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - CollectionView Extension

private extension MypageViewController {
    func setupCollectionView() {
        collectionView.isScrollEnabled = false
        
        // Cell 등록
        collectionView.register(MyInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoCollectionViewCell.className)
        collectionView.register(MypageCollectionViewCell.self, forCellWithReuseIdentifier: MypageCollectionViewCell.className)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            let sectionType = MyPageType.allCases[sectionIndex]
            
            switch sectionType {
            case .userInfo:
                return self.createMyInfoSection()
            case .alarmSetting:
                return self.createAnthoerSection(height: 57)
            case .appService:
                return self.createAnthoerSection(height: 147)
            case .userAuth:
                return self.createAnthoerSection(height: 102)
            }
        }
        
        // 배경 뷰 등록
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: "background")
        
        return layout
    }
    
    func createMyInfoSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(86)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 12, trailing: 20)

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
    
    func createAnthoerSection(height: CGFloat) -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(57)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(height)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 30
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 20, bottom: 25, trailing: 20)
        
        // 배경 추가
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)
        section.decorationItems = [backgroundDecoration]

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
}

extension MypageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MyPageType.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyPageType.allCases[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = MyPageType.allCases[indexPath.section]
        
        switch section {
        case .userInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCollectionViewCell.className, for: indexPath) as! MyInfoCollectionViewCell
            
            cell.configureCell(forModel: UserInfoModel(userName: "이민지", studentId: "20100890", university: "서울과학기술대학교", isAuthenticated: true))
            
            return cell
        
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageCollectionViewCell.className, for: indexPath) as! MypageCollectionViewCell
            
            cell.configureCell(title: section.items[indexPath.row])
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = MyPageType.allCases[indexPath.section]
        selectedCellSubject.send((section: section, index: indexPath.row))
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("MypageViewController") {
//    MypageViewController()
//        .showPreview()
//}
//#endif
