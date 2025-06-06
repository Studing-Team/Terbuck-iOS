//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Foundation
import Combine

import Shared

enum HomeError: LocalizedError, Equatable {
    case serverFailed
    case unknown
    
    var errorDescription: String {
        switch self {
        case .serverFailed:
            return "다시 시도해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public final class HomeViewModel {
    
    // MARK: - Properties
    
    private var searchStoreUseCase: SearchStoreUseCase
    private var searchPartnershipUseCase: SearchPartnershipUseCase
    
    // MARK: - Private Combine Publishers Properties
    
    private(set) var isAuthStudentSubject = CurrentValueSubject<Bool, Never>(false)
    private(set) var selectedFilterSubject = CurrentValueSubject<StoreFilterType, Never>(.restaurent)
    private let homeErrorSubject = PassthroughSubject<HomeError, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Combine Publishers Properties
    
    var sectionDataSubject = CurrentValueSubject<[HomeSection: [HomeItem]], Never>([:])
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let studentIDCardButtonTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let studentIDCardButtonResult: AnyPublisher<Bool, Never>
        let authStudentResult: AnyPublisher<Bool, Never>
        let homeError: AnyPublisher<HomeError, Never>
    }
    
    // MARK: - Init
    
    public init(
        searchStoreUseCase: SearchStoreUseCase,
        searchPartnershipUseCase: SearchPartnershipUseCase
    ) {
        self.searchStoreUseCase = searchStoreUseCase
        self.searchPartnershipUseCase = searchPartnershipUseCase
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
                        .handleEvents(receiveCompletion: { [weak self] completion in
                            if case .failure(let error) = completion {
                                self?.homeErrorSubject.send(error)
                            }
                        })
                        .map { stores in
                            stores.map { HomeItem.restaurant($0) }
                        }
                        .catch { _ in Empty() }
                        .eraseToAnyPublisher()
                    
                case .convenient:
                    return self.postNearStorePublisher()
                        .handleEvents(receiveCompletion: { [weak self] completion in
                            if case .failure(let error) = completion {
                                self?.homeErrorSubject.send(error)
                            }
                        })
                        .map { stores in
                            stores.map { HomeItem.convenient($0) }
                        }
                        .catch { _ in Empty() }
                        .eraseToAnyPublisher()
                    
                case .partnership:
                    return self.postPartnershipPublisher()
                        .handleEvents(receiveCompletion: { [weak self] completion in
                            if case .failure(let error) = completion {
                                self?.homeErrorSubject.send(error)
                            }
                        })
                        .map { partnerships in
                            (partnerships ?? []).map { HomeItem.partnership($0) }
                        }
                        .catch { _ in Empty() }
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
            studentIDCardButtonResult: studentIDCardButtonResult,
            authStudentResult: isAuthStudentSubject.eraseToAnyPublisher(),
            homeError: homeErrorSubject.eraseToAnyPublisher()
        )
    }
}

private extension HomeViewModel {
    func postNearStorePublisher() -> AnyPublisher<[NearStoreModel], HomeError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let result = try await self.searchStoreUseCase.execute(category: self.selectedFilterSubject.value.title)
                    promise(.success(result))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func postPartnershipPublisher() -> AnyPublisher<[PartnershipModel]?, HomeError> {
        return Future { [weak self] promise in
            
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            let categoryfilter = selectedFilterSubject.value.title
            
            Task {
                do {
                    let partnershipResult = try await self.searchPartnershipUseCase.searchExecute()
                    let newPartnershipResult = try await self.searchPartnershipUseCase.newSearchExecute()
                    
                    promise(.success(partnershipResult + newPartnershipResult))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
