
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
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let titleLogo = TerbuckLogoLabel(type: .medium)
    private let studentIDCardButton = UIButton()
    private let segmentedTabView = SegmentedTabView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        
        output.filterResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filterData in
                self?.collectionView.reloadData()
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
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.className)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Extensions

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

// MARK: - UICollectionViewDataSource Extensions

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.storeDataSubject.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.className, for: indexPath) as? StoreCollectionViewCell else { return UICollectionViewCell() }
        
        let data = homeViewModel.storeDataSubject.value[indexPath.row]
        cell.configureCell(forModel: data)
        
        cell.onMoreBenefitTapped { [weak self] in
            self?.showStoreBenefitAlert(storeName: data.storeName, address: data.address, category: data.cateotry, benefitData: data.subBenefit ?? [])
        }
        
        return cell
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
