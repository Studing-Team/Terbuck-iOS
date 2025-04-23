//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Combine

import Shared

public final class HomeViewModel {
    
    // MARK: - Combine Publishers Properties
    
    private(set) var selectedFilterSubject = CurrentValueSubject<StoreFilterType, Never>(.restaurent)
    public let storeDataSubject = CurrentValueSubject<[NearStoreModel], Never>([])
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
//        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let filterResult: AnyPublisher<[NearStoreModel], Never>
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        selectedFilterSubject
            .flatMap { [weak self] filter in
                // TODO: - API 호출
                
                let example = [
                    NearStoreModel(storeName: "GTS버거 공릉점", address: "서울 노원구 동일로190길 49", mainBenefit: "포장 이용 고객 인당 음료 1캔 + 해시브라운 1개 증정"),
                    NearStoreModel(storeName: "우아즈", address: "서울 노원구 공릉로27길 72-3 1층", mainBenefit: "학생증 제시 시, 음료 메뉴 10% 할인"),
                    NearStoreModel(storeName: "샹츠마라", address: "서울 노원구 공릉로 229-1 101동", mainBenefit: "학생증 제시 시, 꿔바로우 사이즈업"),
                    NearStoreModel(storeName: "아소코", address: "서울 노원구 동일로184길 53 1층", mainBenefit: "평일(공휴일 제외)에 한해 학생증 제시 시, 2인당 음료 1캔 제공"),
                    NearStoreModel(storeName: "언제나 케이크", address: "서울 노원구 공릉로 191-45 1층", mainBenefit: "케이크 미니 사이즈 1,000원 할인", subBenefit: ["1호 사이즈 2,000원 할인", "2,3 호 사이즈 3,000원 할인"]),
                    NearStoreModel(storeName: "보각보각", address: "서울 노원구 동일로184길 57 1층", mainBenefit: "학생증 제시 시, 테이블당 소주 혹은 맥주 1병 제공")
                ]
                
                return Just(example).eraseToAnyPublisher()
                
            }
            .sink { [weak self] stores in
                self?.storeDataSubject.send(stores)
            }
            .store(in: &cancellables)
        
        return Output(
            filterResult: storeDataSubject.eraseToAnyPublisher()
        )
    }
}
