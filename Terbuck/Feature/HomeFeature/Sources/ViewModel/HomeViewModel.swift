//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Foundation
import Combine
import CoreLocation

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
    
    private let locationManager = CLLocationManager()
    private var searchStoreUseCase: SearchStoreUseCase
    private var searchPartnershipUseCase: SearchPartnershipUseCase
    
    // MARK: - Private Combine Publishers Properties
    
    private let isAuthStudentSubject = CurrentValueSubject<Bool?, Never>(nil)
    private(set) var selectedFilterSubject = CurrentValueSubject<StoreFilterType, Never>(.restaurent)
    private let homeErrorSubject = PassthroughSubject<HomeError, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Combine Publishers Properties
    
    var sectionDataSubject = CurrentValueSubject<[HomeSection: [HomeItem]], Never>([:])
    public let myLocationSubject = CurrentValueSubject<(latitude: Double?, longitude: Double?), Never>((nil, nil))
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let studentIDCardButtonTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let studentIDCardButtonResult: AnyPublisher<Bool, Never>
        let authStudentResult: AnyPublisher<Bool?, Never>
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
                guard let self, let result = isAuthStudentSubject.value else { return false }
                return result
            }
            .eraseToAnyPublisher()
        
        selectedFilterSubject
            .combineLatest(myLocationSubject)
            .flatMap { [weak self] filter, location -> AnyPublisher<[HomeItem], Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                
                // 위치 인증 여부 확인
                var isLocationAuthorized = false
                
                switch self.locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    isLocationAuthorized = true
                default:
                    isLocationAuthorized = false
                }
                
                switch filter {
                case .restaurent:
                    if isLocationAuthorized == false {
                       // 권한 X : 위치 nil 로 호출
                       return self.postNearStorePublisher(latitude: nil, longitude: nil)
                           .handleEvents(receiveCompletion: { [weak self] completion in
                               if case .failure(let error) = completion {
                                   self?.homeErrorSubject.send(error)
                               }
                           })
                           .map { stores in
                               stores.map { filter == .restaurent ? HomeItem.restaurant($0) : HomeItem.convenient($0) }
                           }
                           .catch { _ in Empty() }
                           .eraseToAnyPublisher()
                   } else {
                       // 권한 O : 위치 값 들어온 경우에만 호출
                       guard let latitude = location.latitude, let longitude = location.longitude else {
                           // 위치 값 아직 없음 → 빈 스트림 리턴
                           return Empty().eraseToAnyPublisher()
                       }
                       
                       return self.postNearStorePublisher(latitude: latitude, longitude: longitude)
                           .handleEvents(receiveCompletion: { [weak self] completion in
                               if case .failure(let error) = completion {
                                   self?.homeErrorSubject.send(error)
                               }
                           })
                           .map { stores in
                               stores.map { filter == .restaurent ? HomeItem.restaurant($0) : HomeItem.convenient($0) }
                           }
                           .catch { _ in Empty() }
                           .eraseToAnyPublisher()
                   }
                    
                case .convenient:
                    let location = myLocationSubject.value
                    
                    return self.postNearStorePublisher(latitude: location.latitude, longitude: location.longitude)
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

// MARK: - Public Func Extension

public extension HomeViewModel {
    func updateMyLocation(latitude: Double?, longitude: Double?) {
        myLocationSubject.send((latitude, longitude))
    }
}

// MARK: - Private API Extension

private extension HomeViewModel {
    func postNearStorePublisher(latitude: Double?, longitude: Double?) -> AnyPublisher<[NearStoreModel], HomeError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let latitudeString = latitude.map { String($0) }
                    let longitudeString = longitude.map { String($0) }
                    
                    let result = try await self.searchStoreUseCase.execute(
                        category: self.selectedFilterSubject.value.title,
                        latitude: latitudeString,
                        longitude: longitudeString
                    )
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
