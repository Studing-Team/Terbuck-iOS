//
//  SearchStoreViewController.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/21/25.
//

import UIKit
import Combine

import DesignSystem
import Shared

import SnapKit
import Then

enum SearchItem: Hashable {
    case currentSearch(CurrentSearchModel)
    case searchResult(StoreListModel)
}

final class SearchStoreViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, SearchItem>!
    
    private let storeMapViewModel: StoreMapViewModel
    weak var coordinator: StoreCoordinator?
    
    // MARK: - Combine Properties

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let backButton = UIButton()
    private let rightSearchImageView = UIImageView()
    private let textField = UITextField()
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }()
    
    private let currentSerachResultLabel = UILabel()
    
    // MARK: - Init
    
    public init(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator
    ) {
        self.storeMapViewModel = storeMapViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
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
        setupDelegate()
        setupCollectionView()
        setupDataSource()
        bindViewModel()
        
        storeMapViewModel.searchTextFieldSubject.send("")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        storeMapViewModel.searchTextFieldSubject.send(textField.text ?? "")
    }
}

// MARK: - Private Bind Extensions

private extension SearchStoreViewController {
    func bindViewModel() {
        storeMapViewModel.filteredSearchResultStoreListSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self else { return }

                let keyword = self.textField.text ?? ""
                self.updateSnapshot(
                    keyword: keyword,
                    currentSearches: [],
                    searchResults: result
                )
            }
            .store(in: &cancellables)
        
        storeMapViewModel.storeSearchKeywordSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self else { return }

                self.updateSnapshot(
                    keyword: "",
                    currentSearches: result,
                    searchResults: []
                )
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension SearchStoreViewController {
    func setupCollectionView() {
        collectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            $0.showsVerticalScrollIndicator = false
            $0.collectionViewLayout = layout
        }
        
        // Cell 등록 (최근 검색, 검색 시)
        collectionView.register(CurrentSearchStoreCollectionViewCell.self, forCellWithReuseIdentifier: CurrentSearchStoreCollectionViewCell.className)
        collectionView.register(SearchStoreCollectionViewCell.self, forCellWithReuseIdentifier: SearchStoreCollectionViewCell.className)
        
        // 커스텀 헤더 뷰 등록
        collectionView.register(
            CustomHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CustomHeaderCollectionReusableView.className
        )
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, SearchItem>(collectionView: collectionView) { collectionView, indexPath, item in

            switch item {
            case .currentSearch(let store):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentSearchStoreCollectionViewCell.className, for: indexPath) as! CurrentSearchStoreCollectionViewCell
                
                cell.configureCell(store)
                cell.configureButtonAction { [weak self] searchData in
                    self?.storeMapViewModel.deleteSearchModelSubject.send(searchData)
                }
                
                return cell
            case .searchResult(let model):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchStoreCollectionViewCell.className, for: indexPath) as! SearchStoreCollectionViewCell
                
                let keyword = self.textField.text ?? ""
                cell.configureCell(forModel: model, searchTitle: keyword)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomHeaderCollectionReusableView.className,
                for: indexPath
            ) as! CustomHeaderCollectionReusableView
   
            return headerView
        }
    }
    
    func updateSnapshot(keyword: String, currentSearches: [CurrentSearchModel], searchResults: [StoreListModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchItem>()
        snapshot.appendSections([.main])

        if keyword.isEmpty {
            let currentItems = currentSearches.map { SearchItem.currentSearch($0) }
            snapshot.appendItems(currentItems)
        } else {
            let resultItems = searchResults.map { SearchItem.searchResult($0) }
            snapshot.appendItems(resultItems)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Private Extensions

private extension SearchStoreViewController {
    func setupStyle() {
        self.view.backgroundColor = .white
        
        containerView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite5)
            $0.layer.cornerRadius = 16
        }
        
        backButton.do {
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            let image = UIImage(systemName: "chevron.left", withConfiguration: config)
            $0.setImage(image, for: .normal)
            $0.tintColor = DesignSystem.Color.uiColor(.terbuckBlack30)
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        rightSearchImageView.do {
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            $0.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
            $0.tintColor = DesignSystem.Color.uiColor(.terbuckGreen50)
            $0.contentMode = .scaleAspectFit
        }
        
        textField.do {
            $0.placeholder = "우리 대학 제휴 업체는?"
            $0.font = DesignSystem.Font.uiFont(.textRegular16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        currentSerachResultLabel.do {
            $0.text = "최근 검색어"
            $0.font = DesignSystem.Font.uiFont(.textSemi16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(containerView, collectionView)
        containerView.addSubviews(backButton, rightSearchImageView, textField)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        backButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.size.equalTo(24)
        }
        
        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(14.5)
            $0.leading.equalTo(backButton.snp.trailing).offset(12)
            $0.trailing.equalTo(rightSearchImageView.snp.leading).inset(5)
        }
        
        rightSearchImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        collectionView.delegate = self
    }
}

extension SearchStoreViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .currentSearch(let model):
            storeMapViewModel.currentSearchTappedSubject.send(model)
            
            view.endEditing(true)
            navigationController?.popViewController(animated: false)

        case .searchResult(let model):
            // 검색 결과 항목을 눌렀을 때의 처리)
            MixpanelManager.shared.track(eventType: TrackEventType.TerbuckMap.searchResultTapped)
            storeMapViewModel.storeMapTypeSubject.send(.searchResult)
            storeMapViewModel.searchListStoreTappedSubject.send(model)
            view.endEditing(true)
            navigationController?.popViewController(animated: false)
        }
    }
}

extension SearchStoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
        }

        switch item {
        case .currentSearch:
            return CGSize(width: UIScreen.main.bounds.width, height: 55)
        case .searchResult:
            return CGSize(width: UIScreen.main.bounds.width, height: 103)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // 현재 snapshot 을 가져오기
        let snapshot = dataSource.snapshot()
        
        // currentSearch 타입이 포함되어 있으면 헤더 표시
        let hasCurrentSearchItems = snapshot.itemIdentifiers.contains {
            if case .currentSearch = $0 {
                return true
            } else {
                return false
            }
        }
        
        if hasCurrentSearchItems {
            return CGSize(width: collectionView.frame.width, height: 55)
        } else {
            return .zero
        }
    }
}

extension SearchStoreViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("SearchStoreViewController") {
//    SearchStoreViewController()
//        .showPreview()
//}
//#endif
