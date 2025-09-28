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
    private let searchStoreUseCase: SearchStoreUseCase
    private let searchPartnershipUseCase: SearchPartnershipUseCase
    private let fetchPartnershipDisclosureStatusUseCase: FetchPartnershipDisclosureStatusUseCase
    private let requestPartnershipDisclosureUseCase: RequestPartnershipDisclosureUseCase
    private let fetchDisclosureRequestStatusUseCase: FetchDisclosureRequestStatusUseCase
    private let fetchApprovedStudentIdStatusUseCase: FetchApprovedStudentIdStatusUseCase
    
    // MARK: - Private Combine Publishers Properties
    
    private let isAuthStudentSubject = CurrentValueSubject<Bool?, Never>(nil)
    private(set) var selectedFilterSubject = CurrentValueSubject<StoreFilterType, Never>(.restaurent)
    private let homeErrorSubject = PassthroughSubject<HomeError, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Combine Publishers Properties
    
    public var homeDataStateSubject = CurrentValueSubject<HomeDataStateType, Never>(.loading)
    public var sectionDataSubject = CurrentValueSubject<[HomeSection: [HomeItem]], Never>([:])
    public let myLocationSubject = CurrentValueSubject<(latitude: Double?, longitude: Double?), Never>((nil, nil))
    public let emptyStateButtonTapSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let studentIDCardButtonTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let studentIDCardButtonResult: AnyPublisher<AuthStudentCardType, Never>
        let authStudentResult: AnyPublisher<Bool?, Never>
        let homeError: AnyPublisher<HomeError, Never>
    }
    
    // MARK: - Init
    
    public init(
        searchStoreUseCase: SearchStoreUseCase,
        searchPartnershipUseCase: SearchPartnershipUseCase,
        fetchPartnershipDisclosureStatusUseCase: FetchPartnershipDisclosureStatusUseCase,
        requestPartnershipDisclosureUseCase: RequestPartnershipDisclosureUseCase,
        fetchDisclosureRequestStatusUseCase: FetchDisclosureRequestStatusUseCase,
        fetchApprovedStudentIdStatusUseCase: FetchApprovedStudentIdStatusUseCase
    ) {
        self.searchStoreUseCase = searchStoreUseCase
        self.searchPartnershipUseCase = searchPartnershipUseCase
        self.fetchPartnershipDisclosureStatusUseCase = fetchPartnershipDisclosureStatusUseCase
        self.requestPartnershipDisclosureUseCase = requestPartnershipDisclosureUseCase
        self.fetchDisclosureRequestStatusUseCase = fetchDisclosureRequestStatusUseCase
        self.fetchApprovedStudentIdStatusUseCase = fetchApprovedStudentIdStatusUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        // viewDidLoad 이벤트 처리
        input.viewLifeCycleEventAction
            .filter { $0 == .viewDidLoad }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.homeDataStateSubject.send(.loading)
            })
            .flatMap { [weak self] _ -> AnyPublisher<HomeDataStateType, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }

                return self.fetchPartnershipDisclosureStatusPublisher()
                    .catch { _ in Just(false) }
                    .flatMap { isDisclosed in
                        self.checkRequestStatus(isDisclosed: isDisclosed)
                    }
                    .eraseToAnyPublisher()
            }
            .delay(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .sink { [weak self] state in
                self?.homeDataStateSubject.send(state)
                if state == .existData {
                    self?.selectedFilterSubject.send(.restaurent)
                }
            }
            .store(in: &cancellables)

        // viewWillAppear 이벤트 처리
        input.viewLifeCycleEventAction
            .filter { $0 == .viewWillAppear }
            .sink { [weak self] _ in
                self?.isAuthStudentSubject.send(UserDefaultsManager.shared.bool(for: .isStudentIDAuthenticated))
            }
            .store(in: &cancellables)
        
        let studentIDCardButtonResult = input.studentIDCardButtonTap
            .handleEvents(receiveOutput: { _ in
                MixpanelManager.shared.track(eventType: TrackEventType.Home.studentCardButtonTapped)
            })
            .flatMap { [weak self] _ -> AnyPublisher<(isAuth: Bool, isPending: Bool), Never> in
                guard let self = self else {
                    return Just((isAuth: false, isPending: false)).eraseToAnyPublisher()
                }
                
                let isAuthPublisher = self.isAuthStudentSubject.compactMap { $0 }.first()
                let isPendingPublisher = self.fetchApprovedStudentIdStatusPublisher().catch { _ in Just(false) }
                    
                return Publishers.Zip(isAuthPublisher, isPendingPublisher)
                    .map { (isAuth: $0.0, isPending: $0.1) }
                    .eraseToAnyPublisher()
            }
            .map { (isAuth, isPending) -> AuthStudentCardType in
                if isAuth {
                    return .showStudentCard
                }
                
                if isPending {
                    return .pendingMessage
                }
                
                // 인증도, 심사중도 아닐 때만 온보딩 여부를 확인
                let hasCompletedOnboarding = UserDefaultsManager.shared.bool(for: .isOnboarding)
                return hasCompletedOnboarding ? .registerMessage : .showOnboarding
            }
            .eraseToAnyPublisher()
        
        selectedFilterSubject
            .filter { [weak self] _ in
                return self?.homeDataStateSubject.value == .existData
            }
            .handleEvents(receiveOutput: { type in
                switch type {
                case .restaurent:
                    MixpanelManager.shared.track(eventType: TrackEventType.Home.eatingButtonTapped)
                case .convenient:
                    MixpanelManager.shared.track(eventType: TrackEventType.Home.usingButtonTapped)
                case .partnership:
                    MixpanelManager.shared.track(eventType: TrackEventType.Home.partnershipButtonTapped)
                }
            })
            .combineLatest(myLocationSubject)
            .flatMap { [weak self] filter, location -> AnyPublisher<[HomeItem], Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                
                switch filter {
                case .restaurent, .convenient:
                    return self.fetchStoreItems(for: filter, location: location)
                case .partnership:
                    return self.fetchPartnershipItems()
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
        
        emptyStateButtonTapSubject
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                
                return self.requestPartnershipDisclosurePublisher()
                    .catch { _ in Just(false) }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] result in
                if result {
                    self?.homeDataStateSubject.send(.requestPartner)
                }
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

// MARK: - Private Extension

private extension HomeViewModel {
    
    // MARK: - High-Level Fetch Logic
    
    /// 필터 유형과 위치 정보에 따라 주변 상점 정보를 비동기적으로 가져와 `HomeItem` 배열로 변환합니다.
    /// - Parameters:
    ///   - filter: 상점 카테고리를 정의하는 `StoreFilterType` (예: .restaurent, .convenient).
    ///   - location: 위도와 경도를 포함하는 튜플. 위치 권한이 없거나 아직 값을 받지 못한 경우 nil일 수 있습니다.
    /// - Returns: `HomeItem`의 배열을 방출하는 `AnyPublisher`를 반환합니다. 에러가 발생하면 빈 배열을 방출합니다.
    func fetchStoreItems(for filter: StoreFilterType, location: (latitude: Double?, longitude: Double?)) -> AnyPublisher<[HomeItem], Never> {
        let isLocationAuthorized: Bool
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isLocationAuthorized = true
        default:
            isLocationAuthorized = false
        }
        
        let publisher: AnyPublisher<[NearStoreModel], HomeError>
        
        if !isLocationAuthorized {
            publisher = postNearStorePublisher(latitude: nil, longitude: nil)
        } else {
            guard let latitude = location.latitude, let longitude = location.longitude else {
                return Empty().eraseToAnyPublisher()
            }
            
            publisher = postNearStorePublisher(latitude: latitude, longitude: longitude)
        }
        
        return publisher
            .handleEvents(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.homeErrorSubject.send(error)
                }
            })
            .map { stores in
                stores.map { filter == .restaurent ? HomeItem.restaurant($0) : HomeItem.convenient($0) }
            }
            .catch { _ in Just([]) }
            .eraseToAnyPublisher()
    }
    
    /// 제휴사 정보를 비동기적으로 가져와 `HomeItem` 배열로 변환합니다.
    /// - Returns: `HomeItem`의 배열을 방출하는 `AnyPublisher`를 반환합니다. 에러가 발생하면 빈 배열을 방출합니다.
    func fetchPartnershipItems() -> AnyPublisher<[HomeItem], Never> {
        return postPartnershipPublisher()
            .handleEvents(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.homeErrorSubject.send(error)
                }
            })
            .map { partnerships in
                partnerships.map { HomeItem.partnership($0) }
            }
            .catch { _ in Just([]) }
            .eraseToAnyPublisher()
    }
    
    /// 제휴 정보 공개 여부에 따라 홈 화면의 상태를 결정합니다.
    /// 공개된 경우 `.existData`를, 비공개인 경우 다시 공개 요청 상태를 확인하여 `.requestPartner` 또는 `.noData`를 반환합니다.
    /// - Parameters:
    ///   - isDisclosed: 제휴 정보 공개 여부를 나타내는 Bool 값.
    /// - Returns: 최종 `HomeDataStateType`을 방출하는 `AnyPublisher`를 반환합니다.
    func checkRequestStatus(isDisclosed: Bool) -> AnyPublisher<HomeDataStateType, Never> {
        if isDisclosed {
            return Just(.existData).eraseToAnyPublisher()
        } else {
            return self.fetchDisclosureRequestStatusPublisher()
                .map { isRequested in
                    return isRequested ? .requestPartner : .noData
                }
                .catch { _ in Just(.noData) }
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Low-Level API Publishers
    
    /// `SearchStoreUseCase`를 사용하여 서버에 주변 상점 정보 조회를 요청합니다.
    /// - Parameters:
    ///   - latitude: 검색 기준이 될 사용자의 현재 위도. `nil`일 경우 서버에서 기본 위치를 사용합니다.
    ///   - longitude: 검색 기준이 될 사용자의 현재 경도. `nil`일 경우 서버에서 기본 위치를 사용합니다.
    /// - Returns: API 응답으로 받은 `[NearStoreModel]` 배열을 방출하거나, 실패 시 `HomeError`를 방출하는 `AnyPublisher`를 반환합니다.
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
    
    /// `SearchPartnershipUseCase`를 사용하여 서버에 일반 및 신규 제휴사 정보 조회를 요청합니다.
    /// - Returns: API 응답으로 받은 `[PartnershipModel]` 배열을 방출하거나, 실패 시 `HomeError`를 방출하는 `AnyPublisher`를 반환합니다.
    func postPartnershipPublisher() -> AnyPublisher<[PartnershipModel], HomeError> {
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
    
    /// `FetchPartnershipDisclosureStatusUseCase`를 사용하여 서버에 대학교 제휴업체 공개 여부 조회를 요청합니다.
    /// - Returns: API 응답으로 받은  Bool 값을 방출하거나, 실패 시 `HomeError`를 방출하는 `AnyPublisher`를 반환합니다.
    func fetchPartnershipDisclosureStatusPublisher() -> AnyPublisher<Bool, HomeError> {
        let universityName = UserDefaultsManager.shared.string(for: .university) ?? ""
        
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let result = try await self.fetchPartnershipDisclosureStatusUseCase.execute(universityName: universityName)
                    
                    promise(.success(result))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// `RequestPartnershipDisclosureUseCase`를 사용하여 서버에 대학교 제휴업체 공개를 요청합니다.
    /// - Returns: API 응답으로 받은  Bool 값을 방출하거나, 실패 시 `HomeError`를 방출하는 `AnyPublisher`를 반환합니다.
    func requestPartnershipDisclosurePublisher() -> AnyPublisher<Bool, HomeError> {
        let universityName = UserDefaultsManager.shared.string(for: .university) ?? ""
        
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let _ = try await self.requestPartnershipDisclosureUseCase.execute(universityName: universityName)
                    
                    promise(.success(true))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// `FetchDisclosureRequestStatusUseCase`를 사용하여 서버에 대학교 제휴업체 공개 요청 실행 여부를 요청합니다.
    /// - Returns: API 응답으로 받은  Bool 값을 방출하거나, 실패 시 `HomeError`를 방출하는 `AnyPublisher`를 반환합니다.
    func fetchDisclosureRequestStatusPublisher() -> AnyPublisher<Bool, HomeError> {
        let universityName = UserDefaultsManager.shared.string(for: .university) ?? ""
        
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let result = try await self.fetchDisclosureRequestStatusUseCase.execute(universityName: universityName)
                    
                    promise(.success(result))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchApprovedStudentIdStatusPublisher() -> AnyPublisher<Bool, HomeError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let result = try await self.fetchApprovedStudentIdStatusUseCase.execute()
                    promise(.success(result))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
