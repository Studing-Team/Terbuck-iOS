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
    
    private var latitude: Double?
    private var longitude: Double?
    
    
    // MARK: - Input Combine Publishers Properties
    
    public let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    public let storeCategoryPublisher = PassthroughSubject<Int, Never>()
    public let markerTappedSubject = PassthroughSubject<StoreListModel, Never>()
    public let didSelectItemSubject = PassthroughSubject<Int, Never>()
    public let latitudeSubject = CurrentValueSubject<Double?, Never>(nil)
    public let longitudeSubject = CurrentValueSubject<Double?, Never>(nil)
    
    // MARK: - Output Combine Publishers Properties
    
    public let storeListSubject = CurrentValueSubject<[StoreListModel], Never>([])
    public let categoryItemsSubject = CurrentValueSubject<[CategoryModel], Never>([])
    public let storeItemsTappedResult = PassthroughSubject<Int, Never>()

    private var cancellables = Set<AnyCancellable>()
    
    private let storeMapErrorSubject = PassthroughSubject<StoreMapError, Never>()

    
    // MARK: - Init
    
    public init(
        searchStoreMapUseCase: SearchStoreMapUseCase
    ) {
        self.searchStoreMapUseCase = searchStoreMapUseCase
        binding()
        fetchStoreCategory()
    }
    
    // MARK: - Public methods
    
    func binding() {
        viewLifeCycleSubject
            .sink { [weak self] event in
                guard let self else { return }
                if event == .viewDidLoad {
                    self.fetchStoreCategory()
                }
            }
            .store(in: &cancellables)
        
        storeCategoryPublisher
            .combineLatest(latitudeSubject, longitudeSubject)
            .compactMap { category, lat, lng -> (Int, Double, Double)? in
                guard let lat, let lng else { return nil }
                return (category, lat, lng)
            }
            .handleEvents(receiveOutput: { [weak self] tuple in
                let (categoryIndex, _, _) = tuple
                self?.updateCategorySelection(to: categoryIndex)
            })
            .flatMap { [weak self] tuple -> AnyPublisher<[StoreListModel], Never> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                let (categoryIndex, lat, lng) = tuple
                
                let categoryItems = categoryItemsSubject.value
                let categoryName = categoryIndex == 0 ? "" : categoryItems[categoryIndex].type.title
                
                return self.getStoreDataPublisher(category: categoryName, lat: lat, lng: lng)
                    .handleEvents(receiveCompletion: { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.storeMapErrorSubject.send(error)
                        }
                    })
                    .catch { _ in Just([]) }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] storeList in
                storeList.forEach {
                    self?.cachedItems[$0.id] = $0
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
    func getStoreDataPublisher(category: String, lat: Double, lng: Double) -> AnyPublisher<[StoreListModel], StoreMapError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
 
            Task {
                do {
                    let result = try await self.searchStoreMapUseCase.execute(category: category, latitude: String(lat), longitude: String(lng))
                    promise(.success(result))
                } catch {
                    promise(.failure(.studentInfoFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


private extension StoreMapViewModel {
    func fetchStoreCategory() {
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
}
