//
//  HomeViewController.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import UIKit
import Combine
import CoreLocation

import DesignSystem
import Shared
import Resource

import SnapKit
import Then
import Lottie

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeViewModel: HomeViewModel
    weak var coordinator: HomeCoordinator?
    private var holeLocation: CGRect?
    
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let titleLogo = TerbuckLogoLabel(type: .medium)
    private let studentIDCardButton = DesignSystem.Button.studentIDCardButton()
    private var segmentedTabHeaderView: SegmentedTabHeaderView?
    private lazy var refreshControl = UIRefreshControl()
    private let activityIndicator = LottieAnimationView(name: "LoadingIndicator", bundle: ResourceResources.bundle).then {
        $0.loopMode = .loop
        $0.contentMode = .scaleAspectFit
        $0.animationSpeed = 1.0
    }
    private let contentLayoutGuide = UILayoutGuide()
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    }()
    
    private lazy var emptyStateView = EmptyStateView(type: .notRequest)
    private lazy var emptyStateBottomButton = TerbuckBottomButton(type: .requestPartner)
    
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
        
        setupStyle(UserDefaultsManager.shared.bool(for: .isStudentIDAuthenticated))
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        setupCollectionView()
        setupDataSource()
        setupLocationManager()
        observeUserAuthUpdate()
        viewLifeCycleSubject.send(.viewDidLoad)
        
        requestLocation()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewLifeCycleSubject.send(.viewWillAppear)
        self.showCustomTabBar()
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
            .sink { [weak self] action in
                guard let self else { return }
                
                switch action {
                case .showOnboarding:
                    guard let holeLocation = self.holeLocation else { return }
                    self.coordinator?.startRegisterStudentCard(for: .onboarding, location: holeLocation)
                    UserDefaultsManager.shared.set(true, for: .isOnboarding)
                    
                case .pendingMessage:
                    ToastManager.shared.showToast(from: self, type: .approvedStudentCard(type: .home))
                    
                case .registerMessage:
                    ToastManager.shared.showToast(from: self, type: .notAuthorized(type: .home)) {
                        self.coordinator?.startRegisterStudentCard(for: .register, location: nil)
                    }
                    
                case .showStudentCard:
                    self.coordinator?.startRegisterStudentCard(for: .auth, location: nil)
                }
            }
            .store(in: &cancellables)
        
        output.authStudentResult
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authResult in
                guard let self else { return }

                studentIDCardButton.setImage(authResult ? .authIdCard : .notAuthIdCard, for: .normal)
            }
            .store(in: &cancellables)
        
        homeViewModel.sectionDataSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sectionData in

                self?.applySnapshot()
                self?.collectionView.setContentOffset(.zero, animated: true)
            }
            .store(in: &cancellables)
        
        homeViewModel.homeDataStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateLayoutToDataExist(state)
            }
            .store(in: &cancellables)
        
        // segmentedTabHeaderView는 supplementaryViewProvider에서 바인딩됨
        
        homeViewModel.currentMyUniversitySubject
            .filter { !$0.isEmpty }
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.viewLifeCycleSubject.send(.reloadData)
            }
            .store(in: &cancellables)
        
        // 배너 데이터는 이제 CollectionView 섹션으로 처리됨
        
    }
}

// MARK: - Private Extensions

private extension HomeViewController {
    func setupStyle(_ isAuth: Bool) {
        self.view.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite3)
        navigationItem.backButtonTitle = ""
        
        studentIDCardButton.setImage(isAuth ? .authIdCard : .notAuthIdCard, for: .normal)
        
        [collectionView, emptyStateView, emptyStateBottomButton].forEach {
            $0.isHidden = true
        }
    }
    
    func setupHierarchy() {
        view.addLayoutGuide(contentLayoutGuide)
        
        self.view.addSubviews(titleLogo, studentIDCardButton, collectionView, emptyStateView, emptyStateBottomButton, activityIndicator)
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
        
        contentLayoutGuide.snp.makeConstraints {
            $0.top.equalTo(titleLogo.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLogo.snp.bottom).offset(view.convertByHeightRatio(20))
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyStateView.snp.makeConstraints {
            $0.top.equalTo(titleLogo.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyStateBottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(contentLayoutGuide)
            $0.size.equalTo(view.convertByHeightRatio(200))
        }
    }
    
    func setupDelegate() {
        collectionView.delegate = self
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func requestLocation() {
        switch self.locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            AppLogger.log("위치 권한 이미 허용됨. 위치 업데이트 시작.", .info, .service)
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            AppLogger.log("위치 권한이 거부되었거나 제한된 상태", .error, .service)
        default:
            break
        }
    }
    
    func observeUserAuthUpdate() {
        NotificationCenter.default.publisher(for: .userAuthDidUpdate)
            .sink { [weak self] notification in
                guard let self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    ToastManager.shared.showToast(from: self, type: .alarmStudentCard) {
                        MixpanelManager.shared.track(eventType: TrackEventType.Home.alarmButtonInToastMessage)
                        self.coordinator?.showAlarmSetting()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func updateLayoutToDataExist(_ state: HomeDataStateType) {
        var viewsToShow: [UIView] = []
        var viewsToHide: [UIView] = []
        
        switch state {
        case .loading:
            viewsToShow = [activityIndicator]
            viewsToHide = [collectionView, emptyStateView, emptyStateBottomButton]
            activityIndicator.play()
            
        case .noData:
            viewsToShow = [emptyStateView, emptyStateBottomButton]
            viewsToHide = [activityIndicator, collectionView]
            
            emptyStateView.changeState(.notRequest)
            emptyStateView.snp.remakeConstraints {
                $0.top.equalTo(titleLogo.snp.bottom).offset(view.convertByHeightRatio(15))
                $0.horizontalEdges.equalToSuperview()
            }
            
            if emptyStateBottomButton.actions(forTarget: self, forControlEvent: .touchUpInside) == nil {
                emptyStateBottomButton.addTarget(self, action: #selector(emptyStateBottomButtonTapped), for: .touchUpInside)
            }
            
        case .requestPartner:
            viewsToShow = [emptyStateView]
            viewsToHide = [activityIndicator, collectionView, emptyStateBottomButton]
            
            emptyStateView.changeState(.completeRequest)
            emptyStateView.snp.remakeConstraints {
                $0.top.equalTo(titleLogo.snp.bottom).offset(view.convertByHeightRatio(15))
                $0.horizontalEdges.equalToSuperview()
            }
            
        case .existData:
            viewsToShow = [collectionView]
            viewsToHide = [activityIndicator, emptyStateView, emptyStateBottomButton]
        }
        
        // 애니메이션 준비: 나타날 뷰들의 isHidden을 false로 설정
        viewsToShow.forEach { $0.isHidden = false }
        
        // 애니메이션 실행
        UIView.animate(withDuration: 0.3, animations: {
            viewsToShow.forEach { $0.alpha = 1.0 }
            
            if state != .loading {
                self.activityIndicator.stop()
            }
            
            viewsToHide.forEach { $0.alpha = 0.0 }
            self.view.layoutIfNeeded() // 제약조건 변경 애니메이션
        }) { finished in
            guard finished else { return }
            // 애니메이션 종료 후, 사라진 뷰들의 isHidden을 true로 설정
            viewsToHide.forEach { $0.isHidden = true }
            
            if state == .requestPartner {
                ToastManager.shared.showToast(from: self, type: .requestPartnership) {
                    self.coordinator?.showAlarmSetting()
                }
            }
        }
    }
    
    @objc private func emptyStateBottomButtonTapped() {
        homeViewModel.emptyStateButtonTapSubject.send()
    }
    
    func bindSegmentedTabHeader(_ headerView: SegmentedTabHeaderView) {
        headerView.selectedFilterPublisher
            .sink { [weak self] filterType in
                self?.homeViewModel.selectedFilterSubject.send(filterType)
            }
            .store(in: &cancellables)
    }
}

// MARK: - CLLocationManagerDelegate
   
extension HomeViewController: CLLocationManagerDelegate {
   public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       guard let location = locations.last else { return }
       
       let latitude = location.coordinate.latitude
       let longitude = location.coordinate.longitude

       homeViewModel.updateMyLocation(latitude: latitude, longitude: longitude)
       self.locationManager.stopUpdatingLocation()
   }
   
   public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       if status == .authorizedWhenInUse || status == .authorizedAlways {
           locationManager.startUpdatingLocation()
       }
   }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.log("Home 위치 업데이트 실패: \(error.localizedDescription)", .error, .service)
    }
}

// MARK: - CollectionView Extension

private extension HomeViewController {
    @objc private func refreshData() {
        // 🔄 데이터 갱신 로직 실행
        self.homeViewModel.selectedFilterSubject.send(homeViewModel.selectedFilterSubject.value)
        self.homeViewModel.myLocationSubject.send(homeViewModel.myLocationSubject.value)

        // 📉 애니메이션 종료
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Cell 등록
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.className)
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.className)
        collectionView.register(PartnershipCollectionViewCell.self, forCellWithReuseIdentifier: PartnershipCollectionViewCell.className)
        
        // 커스텀 헤더 뷰 등록
        collectionView.register(CustomHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CustomHeaderCollectionReusableView.className)
        
        // segmentedTabView를 헤더로 등록
        collectionView.register(SegmentedTabHeaderView.self,
                                forSupplementaryViewOfKind: "SegmentedTabHeader", 
                                withReuseIdentifier: "SegmentedTabHeaderView")
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            let currentSectionData = homeViewModel.sectionDataSubject.value

            // sectionIndex 0은 항상 배너
            if sectionIndex == 0 {
                return self.createBannerSection()
            }
            
            // sectionIndex 1부터는 선택된 필터에 따른 데이터
            switch self.homeViewModel.selectedFilterSubject.value {
            case .restaurent, .convenient:
                if sectionIndex == 1 {
                    return self.createStoreSection(withStickyHeader: true)
                }
                
            case .partnership:
                let hasNew = currentSectionData[.newBenefit]?.isEmpty == false
                let hasGeneral = currentSectionData[.general]?.isEmpty == false

                if hasNew && hasGeneral {
                    if sectionIndex == 1 {
                        return self.createPartnershipNewSection()
                    } else if sectionIndex == 2 {
                        return self.createPartnershipGeneralSection()
                    }
                } else if hasNew && sectionIndex == 1 {
                    return self.createPartnershipNewSection()
                } else if hasGeneral && sectionIndex == 1 {
                    return self.createPartnershipGeneralSection()
                }
            }
            
            return nil
        }
        
        // 배경 뷰 등록
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: "background")
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: "newPartnerBackground")
        
        return layout
    }
    
    func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.width - 40), // 좌우 20pt씩 여백
            heightDimension: .absolute(120)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20)
//        section.interGroupSpacing = 15 // 배너 간 간격
        section.orthogonalScrollingBehavior = .groupPaging // 페이지 단위로 스크롤
        
        return section
    }
    
    func createStoreSection(withStickyHeader: Bool = false) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(400)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(400)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 0)
        section.interGroupSpacing = 15
        
        // segmentedTabView를 Sticky Header로 추가
        if withStickyHeader {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(58) // 48 + 10(하단)
            )
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: "SegmentedTabHeader",
                alignment: .top
            )
            
            header.pinToVisibleBounds = true
            header.zIndex = 1000
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    
    /// 파트너쉽 섹션 중 추가된 새로운 데이터를 표기하기 위한 레이아웃
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
            elementKind: "newPartnerBackground")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 34, leading: 0, bottom: 0, trailing: 0)
        section.decorationItems = [backgroundDecoration]

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
    
    /// 파트너쉽 섹션 중 기존 데이터를 표기하기 위한 레이아웃
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
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 5, trailing: 0)
        section.decorationItems = [backgroundDecoration]

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
}

// MARK: - CollectionView Delegate Extension

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .banner(let model):
            let webViewController = WebViewController()
            webViewController.configure(with: model.linkUrl)
            self.present(webViewController, animated: true)
            
        case .partnership(let model):
            self.coordinator?.showPartnership(partnershipId: model.id)
            MixpanelManager.shared.track(eventType: TrackEventType.Home.moveDetailPartnership)
        default:
            break
        }
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
            case .banner(let model):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BannerCollectionViewCell.className,
                    for: indexPath
                ) as! BannerCollectionViewCell
                
                cell.configure(with: model)
                cell.onBannerTapped = { [weak self] linkUrl in
                    let webViewController = WebViewController()
                    webViewController.configure(with: linkUrl)
                    self?.present(webViewController, animated: true)
                }
                
                return cell
                
            case .restaurant(let model), .convenient(let model):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: StoreCollectionViewCell.className,
                    for: indexPath
                ) as! StoreCollectionViewCell
                
                cell.configureCell(forModel: model)
                
                cell.onMoreBenefitTapped { [weak self] in
                    self?.showStoreBenefitAlert(
                        storeName: model.storeName,
                        address: model.address,
                        category: model.category,
                        benefitData: model.benefitData
                    )
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
        
        // 항상 배너 섹션을 먼저 추가
        if let bannerItems = homeViewModel.sectionDataSubject.value[.banner], !bannerItems.isEmpty {
            snapshot.appendSections([.banner])
            snapshot.appendItems(bannerItems, toSection: .banner)
        }
        
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
            guard let self = self else { return nil }
            
            // segmentedTabView 헤더 처리
            if kind == "SegmentedTabHeader" {
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "SegmentedTabHeaderView",
                    for: indexPath
                ) as! SegmentedTabHeaderView
                
                // 처음 생성될 때만 바인딩 설정
                if self.segmentedTabHeaderView == nil {
                    self.segmentedTabHeaderView = headerView
                    self.bindSegmentedTabHeader(headerView)
                }
                
                return headerView
            }
            
            // 기존 커스텀 헤더 처리
            if kind == UICollectionView.elementKindSectionHeader {
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
