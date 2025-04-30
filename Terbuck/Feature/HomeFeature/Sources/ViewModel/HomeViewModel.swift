//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Foundation
import Combine

import Shared

public final class HomeViewModel {
    
    // MARK: - Combine Publishers Properties
    
    private(set) var isAuthStudentSubject = CurrentValueSubject<Bool, Never>(false)
    private(set) var selectedFilterSubject = CurrentValueSubject<StoreFilterType, Never>(.restaurent)
    
    var sectionDataSubject = CurrentValueSubject<[HomeSection: [HomeItem]], Never>([:])
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let studentIDCardButtonTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let studentIDCardButtonResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        input.viewLifeCycleEventAction
            .sink { [weak self] _ in
                self?.isAuthStudentSubject.send(UserDefaultsManager.shared.bool(for: .isStudentIDAuthenticated))
            }
            .store(in: &cancellables)
        
        let studentIDCardButtonResult = input.studentIDCardButtonTap
            .map { [weak self] _ -> Bool in
                guard let self else { return false }

                // 여기서 로직 처리 예: 인증 여부 확인, 조건 분기 등
               
                return false
            }
            .eraseToAnyPublisher()
        
        selectedFilterSubject
            .flatMap { [weak self] filter -> AnyPublisher<[HomeItem], Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                switch filter {
                case .restaurent:
                    return self.postNearStorePublisher()
                        .map { stores in
                            stores.map { HomeItem.restaurant($0) }
                        }
                        .eraseToAnyPublisher()
                    
                case .convenient:
                    return self.postNearStorePublisher()
                        .map { stores in
                            stores.map { HomeItem.convenient($0) }
                        }
                        .eraseToAnyPublisher()
                    
                    
                case .partnership:
                    return self.postPartnershipPublisher()
                        .map { partnerships in
                            (partnerships ?? []).map { HomeItem.partnership($0) }
                        }
                        .eraseToAnyPublisher()
                }
            }
            .sink { [weak self] items in
                guard let self else { return }

                var sectionData: [HomeSection: [HomeItem]] = [:]

                for item in items {
                    switch item {
                    case .restaurant:
                        sectionData[.restaurant, default: []].append(item)
                        
                    case .convenient:
                        sectionData[.convenient, default: []].append(item)
                        
                    case .partnership(let model):
                        if model.isNewPartner {
                            sectionData[.newBenefit, default: []].append(item)
                        }
                        
                        if !model.isNewPartner {
                            sectionData[.general, default: []].append(item)
                        }
                    }
                }

                self.sectionDataSubject.send(sectionData)
            }
            .store(in: &cancellables)
        
        return Output(
            studentIDCardButtonResult: studentIDCardButtonResult
        )
    }
}

private extension HomeViewModel {
    func postNearStorePublisher() -> AnyPublisher<[NearStoreModel], Never> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            let example = [
                NearStoreModel(storeName: "GTS버거 공릉점", cateotry: .restaurant, address: "서울 노원구 동일로190길 49", mainBenefit: "포장 이용 고객 인당 음료 1캔 + 해시브라운 1개 증정"),
                NearStoreModel(storeName: "우아즈", cateotry: .restaurant, address: "서울 노원구 공릉로27길 72-3 1층", mainBenefit: "학생증 제시 시, 음료 메뉴 10% 할인"),
                NearStoreModel(storeName: "샹츠마라", cateotry: .restaurant, address: "서울 노원구 공릉로 229-1 101동", mainBenefit: "학생증 제시 시, 꿔바로우 사이즈업"),
                NearStoreModel(storeName: "아소코", cateotry: .restaurant, address: "서울 노원구 동일로184길 53 1층", mainBenefit: "평일(공휴일 제외)에 한해 학생증 제시 시, 2인당 음료 1캔 제공"),
                NearStoreModel(storeName: "언제나 케이크", cateotry: .cafe, address: "서울 노원구 공릉로 191-45 1층", mainBenefit: "케이크 미니 사이즈 1,000원 할인", subBenefit: ["1호 사이즈 2,000원 할인", "2,3 호 사이즈 3,000원 할인"]),
                NearStoreModel(storeName: "보각보각", cateotry: .bar, address: "서울 노원구 동일로184길 57 1층", mainBenefit: "학생증 제시 시, 테이블당 소주 혹은 맥주 1병 제공")
            ]
            
            promise(.success(example))
        }
        .eraseToAnyPublisher()
    }
    
    func postPartnershipPublisher() -> AnyPublisher<[PartnershipModel]?, Never> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            let example = [
                PartnershipModel(partnershipName: "서울베스트의료의원", partnerCategoryType: .studentAssociation, storeType: .hospital, isNewPartner: true),
                PartnershipModel(partnershipName: "토익주관사 YBM", partnerCategoryType: .studentAssociation, storeType: .education, isNewPartner: false),
                PartnershipModel(partnershipName: "서울베스트 상단제목의 텍스트 최대넓이는 215 Adobe", partnerCategoryType: .studentAssociation, storeType: .hospital, isNewPartner: true),
                PartnershipModel(partnershipName: "Adobe 공동구매", partnerCategoryType: .studentAssociation, storeType: .education, isNewPartner: false),
                PartnershipModel(partnershipName: "상단제목의 텍스트 최대넓이는 215 Adobe 공동구매", partnerCategoryType: .studentAssociation, storeType: .culture, isNewPartner: false),
                PartnershipModel(partnershipName: "서울", partnerCategoryType: .studentAssociation, storeType: .hospital, isNewPartner: true)
            ]
            
            promise(.success(example))
        }
        .eraseToAnyPublisher()
    }
}
