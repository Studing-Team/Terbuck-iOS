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

public final class StoreMapViewModel {
    
    // MARK: - Properties
    
    private var cachedItems: [String: StoreListModel] = [:]
   
    
    // MARK: - Combine Publishers Properties
    
    let didSelectItemSubject = PassthroughSubject<Int, Never>()
    let markerTappedSubject = PassthroughSubject<StoreListModel, Never>()
    let searchTextFieldSubject = PassthroughSubject<String, Never>()
    let searchStoreSubject = CurrentValueSubject<[StoreListModel], Never>([])
    
    private let storeListDataSubject = CurrentValueSubject<[StoreListModel], Never>([])
    var storeListDataPublisher: AnyPublisher<[StoreListModel], Never> {
        storeListDataSubject.eraseToAnyPublisher()
    }
    
    var storeCategoryPublisher = CurrentValueSubject<[CategoryModel], Never>([])
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let storeListData: AnyPublisher<[StoreListModel], Never>
        let categoryData: AnyPublisher<[CategoryModel], Never>
        let didSelectItem: AnyPublisher<Int, Never>
        let markerPinTappedResult: AnyPublisher<StoreListModel, Never>
        let searchStoreResult: AnyPublisher<[StoreListModel], Never>
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        input.viewLifeCycleEventAction
            .sink { [weak self] event in
                guard let self else { return }
                if event == .viewDidLoad {
                    self.fetchStoreData()
                    self.fetchStoreCategory()
                }
            }
            .store(in: &cancellables)
        
        searchTextFieldSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
                // TODO: - 검색 관련한 로직
            }
            .store(in: &cancellables)

        return Output(
            storeListData: storeListDataSubject.eraseToAnyPublisher(),
            categoryData: storeCategoryPublisher.eraseToAnyPublisher(),
            didSelectItem: didSelectItemSubject.eraseToAnyPublisher(),
            markerPinTappedResult: markerTappedSubject.eraseToAnyPublisher(),
            searchStoreResult: searchStoreSubject.eraseToAnyPublisher()
        )
    }
    
    func item(forId id: String) -> StoreListModel? {
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
}

private extension StoreMapViewModel {
    func fetchStoreData() {
        getStoreDataPublisher()
            .sink { [weak self] data in
                guard let self else { return }
                print("💡 store list count: \(data.count)")
                self.cachedItems = Dictionary(uniqueKeysWithValues: data.map { ($0.id, $0) })
                self.storeListDataSubject.send(data)
            }
            .store(in: &cancellables)
    }
    
    func fetchStoreCategory() {
        let category = CategoryType.allCases.map {
            return CategoryModel(type: $0, isSelected: $0.title == "전체" ? true : false)
        }
        
        storeCategoryPublisher.send(category)
    }
    
    func getStoreDataPublisher() -> AnyPublisher<[StoreListModel], Never> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            let example = [
                StoreListModel(image: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!, storeName: "터벅터벅 공릉점", storeAddress: "서울 노원구 동이로190길 490 지층", category: .restaurant, benefitCount: 2, latitude: 37.52468678447179, longitude: 126.6755638860265),
                StoreListModel(image: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!, storeName: "터벅터벅 공릉점", storeAddress: "서울 노원구 동이로190길 491 지층", category: .restaurant, benefitCount: 2, latitude: 37.52292332189077, longitude: 126.6699605853461),
                StoreListModel(image: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!, storeName: "터벅터벅 공릉점", storeAddress: "서울 노원구 동이로190길 492 지층", category: .restaurant, benefitCount: 2, latitude: 37.52201274703535, longitude: 126.67299627544598),
                StoreListModel(image: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!, storeName: "터벅터벅 공릉점", storeAddress: "서울 노원구 동이로190길 493 지층", category: .restaurant, benefitCount: 2, latitude: 37.522782559157285, longitude: 126.6728006056389),
                StoreListModel(image: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!, storeName: "터벅터벅 공릉점", storeAddress: "서울 노원구 동이로190길 494 지층", category: .restaurant, benefitCount: 2, latitude: 37.522750328076135, longitude: 126.6709285530035),
                StoreListModel(image: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!, storeName: "터벅터벅 공릉점", storeAddress: "서울 노원구 동이로190길 495 지층", category: .restaurant, benefitCount: 2, latitude: 37.52202973167599, longitude: 126.67425185979165),
                StoreListModel(image: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!, storeName: "터벅터벅 공릉점", storeAddress: "서울 노원구 동이로190길 496 지층", category: .restaurant, benefitCount: 2, latitude: 37.52015323931828, longitude: 126.67337768520443)]
            
            promise(.success(example))
        }
        .eraseToAnyPublisher()
    }
}
