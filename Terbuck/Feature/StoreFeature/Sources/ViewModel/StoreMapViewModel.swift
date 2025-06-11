//
//  StoreMapViewModel.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/13/25.
//

import Combine
import UIKit

import DesignSystem
import Shared

enum StoreMapError: LocalizedError, Equatable {
    case studentInfoFailed
    case unknown

    var errorDescription: String {
        switch self {
        case .studentInfoFailed:
            return "유저 정보를 불러올 수 없어요."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public final class StoreMapViewModel {
    
    // MARK: - UseCase Properties
    
    private var searchStoreMapUseCase: SearchStoreMapUseCase
    
    // MARK: - Properties
    
    private var cachedItems: [Int: StoreListModel] = [:]
    private var categoryStoreData: [CategoryType: [StoreListModel]] = [:]
    
    private var currentUniversityName: String?
    private var latitude: Double?
    private var longitude: Double?
    
    // MARK: - Input Combine Publishers Properties
    
    public let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    public let storeMapTypeSubject = CurrentValueSubject<SearchBarType, Never>(.search)
    public let storeCategoryPublisher = CurrentValueSubject<Int, Never>(0)
    public let markerTappedSubject = PassthroughSubject<StoreListModel, Never>()
    public let didSelectItemSubject = PassthroughSubject<Int, Never>()
    public let latitudeSubject = CurrentValueSubject<Double?, Never>(nil)
    public let longitudeSubject = CurrentValueSubject<Double?, Never>(nil)
    public let currentSnapIndex = CurrentValueSubject<Int, Never>(1)
    
    // MARK: - SearchStore Input Combine Publishers Properties
    
    public let searchTextFieldSubject = PassthroughSubject<String, Never>()
    public let searchListStoreTappedSubject = PassthroughSubject<StoreListModel, Never>()
    public let searchResultStoreTappedSubject = CurrentValueSubject<StoreListModel?, Never>(nil)
    
    // MARK: - Output Combine Publishers Properties
    
    public let storeListSubject = CurrentValueSubject<[StoreListModel], Never>([])
    public let categoryItemsSubject = CurrentValueSubject<[CategoryModel], Never>([])
    public let storeItemsTappedResult = PassthroughSubject<Int, Never>()
    public let filteredStoreListSubject = PassthroughSubject<[StoreListModel], Never>()

    private var cancellables = Set<AnyCancellable>()
    
    private let storeMapErrorSubject = PassthroughSubject<StoreMapError, Never>()

    // MARK: - Init
    
    public init(
        searchStoreMapUseCase: SearchStoreMapUseCase
    ) {
        self.searchStoreMapUseCase = searchStoreMapUseCase
        binding()
    }
    
    // MARK: - Public methods
    
    func binding() {
        viewLifeCycleSubject
            .sink { [weak self] type in
                switch type {
                case .viewDidLoad:
                    self?.fetchStoreCategory()
                case .viewWillAppear:
                    let savedUniversityName = UserDefaultsManager.shared.string(for: .university)
                    
                    if let name = self?.currentUniversityName, savedUniversityName != name {
                        self?.fetchStoreCategory()
                    }
                }
            }
            .store(in: &cancellables)
        
        let sharedPublisher = storeCategoryPublisher
            .handleEvents(receiveOutput: { [weak self] index in
                self?.updateCategorySelection(to: index)
            })
            .share()
        
        // ✅ 전체 카테고리일 경우: 서버 호출
        let fetchPublisher = sharedPublisher
            .filter { categoryIndex in categoryIndex == 0 }
            .flatMap { [weak self] categoryIndex -> AnyPublisher<[StoreListModel], Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }

                return self.getStoreDataPublisher(category: "", lat: latitude, lng: longitude)
                    .handleEvents(receiveCompletion: { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.storeMapErrorSubject.send(error)
                        }
                    })
                    .catch { _ in Just([]) }
                    .eraseToAnyPublisher()
            }
        
        // ✅ 특정 카테고리 선택시: 필터링만 수행
        let filterPublisher = sharedPublisher
            .filter { categoryIndex in categoryIndex != 0 }
            .handleEvents(receiveOutput: { [weak self] categoryIndex in
                self?.updateStoreList(to: categoryIndex)
            })
            .map { _ in [StoreListModel]() } // 빈 리스트로 데이터 방출

        // ✅ 병합 후 처리
        Publishers.Merge(fetchPublisher, filterPublisher)
            .sink { [weak self] storeList in
                guard !storeList.isEmpty else { return }
                self?.categoryStoreData.removeAll()
                
                storeList.forEach {
                    self?.cachedItems[$0.id] = $0
                    self?.categoryStoreData[$0.category, default: []].append($0)
                }

                self?.storeListSubject.send(storeList)
            }
            .store(in: &cancellables)
        
        didSelectItemSubject
            .sink { [weak self] index in
                guard let data = self?.storeListSubject.value[index] else { return }
                self?.storeItemsTappedResult.send(data.id)
            }
            .store(in: &cancellables)
        
        
        searchTextFieldSubject
            .sink { [weak self] searchText in
                guard let self = self else { return }

                let searchResult = self.storeListSubject.value.filter { store in
                    let storeName = store.storeName
                    let consonants = self.extractInitialConsonants(from: storeName)

                    return storeName.contains(searchText) || consonants.contains(searchText)
                }

                // 검색 결과를 따로 보낸다면 여기에 전달
                self.filteredStoreListSubject.send(searchResult)
            }
            .store(in: &cancellables)
    }
    
    func item(forId id: Int) -> StoreListModel? {
        return cachedItems[id]
    }
    
    func extractInitialConsonants(from text: String) -> String {
        let base: UInt32 = 0xAC00
        let initialConsonants = [
            "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ",
            "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ",
            "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ",
            "ㅋ", "ㅌ", "ㅍ", "ㅎ"
        ]
        
        var result = ""
        for scalar in text.unicodeScalars {
            let value = scalar.value
            if value >= 0xAC00 && value <= 0xD7A3 {
                let index = Int((value - base) / 28 / 21)
                result.append(initialConsonants[index])
            } else {
                result.append(Character(scalar))
            }
        }
        return result
    }
    
    func updateLocationData(lat: Double, lng: Double) {
        print("위치 업데이트 됐습니다.", lat, lng)
        latitude = lat
        longitude = lng
    }
}

// MARK: - Private API Extension

private extension StoreMapViewModel {
    func getStoreDataPublisher(category: String, lat: Double?, lng: Double?) -> AnyPublisher<[StoreListModel], StoreMapError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let latString = lat.map { String($0) } ?? ""
                    let lngString = lng.map { String($0) } ?? ""
                    
                    let result = try await self.searchStoreMapUseCase.execute(
                        category: category,
                        latitude: latString,
                        longitude: lngString
                    )
                    promise(.success(result))
                } catch {
                    promise(.failure(.studentInfoFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Private Function Extension

private extension StoreMapViewModel {
    func fetchStoreCategory() {
        currentUniversityName = UserDefaultsManager.shared.string(for: .university)
        
        let category = CategoryType.allCases.map {
            return CategoryModel(type: $0, isSelected: $0.title == "전체" ? true : false)
        }
        
        categoryItemsSubject.send(category)
        storeCategoryPublisher.send(0)
    }
    
    func updateCategorySelection(to selectRow: Int) {
        
        var category = categoryItemsSubject.value
        guard let index = category.firstIndex(where: { $0.isSelected }) else { return }
        guard index != selectRow else { return }

        category[index].isSelected = false
        category[selectRow].isSelected = true
        
        categoryItemsSubject.send(category)
    }
    
    func updateStoreList(to selectRow: Int) {
        let categoryData = categoryItemsSubject.value
        guard let categoryStoreList = categoryStoreData[categoryData[selectRow].type] else { return }
        self.storeListSubject.send(categoryStoreList)
    }
}
