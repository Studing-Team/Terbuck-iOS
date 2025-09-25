//
//  CollegeInfoViewModel.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import Foundation
import Combine

import Shared

enum CollegesError: LocalizedError, Equatable {
    case fetchFailed
    case signupFailed
    case notEditUniversity
    case editUniversityFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "대학교 단과대 정보를 불러올 수 없습니다."
        case .signupFailed:
            return "가입 관련해서 문제가 발생했어요."
        case .notEditUniversity:
            return "대학교 인증 문제가 발생했어요."
        case .editUniversityFailed:
            return "대학교 변경 관련해서 문제가 발생했어요."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

@Observable
public class CollegeInfoViewModel {
    
    // MARK: - Properties
    
    private var fetchCollegesInfoListUseCase: FetchCollegesInfoListUseCase
    private var signupUseCase: SignupUseCase?
    private var editUniversityUseCase: EditUniversityUseCase?
    
    // MARK: - Private Combine Publishers Properties
    
    public let selectedUniversityNameSubject = CurrentValueSubject<String, Never>("")
    private let selectedCollegeSubject = CurrentValueSubject<CollegesInfoModel?, Never>(nil)
    private let errorSubject = PassthroughSubject<CollegesError, Never>()
    
    // MARK: - SwiftUI Published Properties
    
    var collegesInfoModel: [CollegesInfoModel]?
    
    // MARK: - Private Combine Publishers Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - SwiftUI Published Properties
    
    var selectedItemForUI: CollegesInfoModel?
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let bottomButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isBottomButtonEnabled: AnyPublisher<Bool, Never>
        let bottomButtonResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Init
    
    public init(
        selectedUniversityName: String,
        fetchCollegesInfoListUseCase: FetchCollegesInfoListUseCase,
        signupUseCase: SignupUseCase? = nil,
        editUniversityUseCase: EditUniversityUseCase? = nil,
    ) {
        self.selectedUniversityNameSubject.send(selectedUniversityName)
        self.fetchCollegesInfoListUseCase = fetchCollegesInfoListUseCase
        self.signupUseCase = signupUseCase
        self.editUniversityUseCase = editUniversityUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        input.viewLifeCycleEventAction
            .filter { $0 == .viewDidLoad }
            .flatMap { [weak self] _ -> AnyPublisher<[CollegesInfoModel], Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                
                let universityName = self.selectedUniversityNameSubject.value
                
                return self.fetchCollegesInfoListPublisher(universityName)
                    .catch { error -> Just<[CollegesInfoModel]> in
                        self.errorSubject.send(error)
                        return Just([])
                    }
                    .eraseToAnyPublisher()
            }
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] collegesData in
                self?.collegesInfoModel = collegesData
            }
            .store(in: &cancellables)
                
        let isBottomButtonEnabled = selectedCollegeSubject
            .map { selectedItem in
                selectedItem == nil ? false : true
            }
            .eraseToAnyPublisher()
        
        let bottomButtonResult = input.bottomButtonTapped
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: false)
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else {
                    return Just(false).eraseToAnyPublisher()
                }
                
                let universityName = self.selectedUniversityNameSubject.value
                
                if let _ = self.signupUseCase,
                   let selectCollege = self.selectedCollegeSubject.value {
                    return self.signupPublisher(universityName, selectCollege.id)
                        .handleEvents(receiveOutput:  { _ in
                            MixpanelManager.shared.track(eventType: TrackEventType.Signup.secondSignupButtonTapped)
                            
                            MixpanelManager.shared.setupUniversity(universityName: universityName)
                        })
                        .map { _ in
                            UserDefaultsManager.shared.set(universityName, for: .university)
                            
                            UserDefaultsManager.shared.set(object: selectCollege, for: .college)
                            return true
                        }
                        .catch { _ in Just(false) }
                        .eraseToAnyPublisher()
                }
                
                if let _ = self.editUniversityUseCase,
                   let collegeId = self.selectedCollegeSubject.value  {
                    return editUniversityPublisher(universityName)
                        .map { _ in
                            UserDefaultsManager.shared.set(false, for: .isStudentIDAuthenticated)
                            UserDefaultsManager.shared.set(universityName, for: .university)
                            MixpanelManager.shared.setupUniversity(universityName: universityName)
                            FileStorageManager.shared.delete(type: .studentIdCard)
                            return true
                        }
                        .catch { error in
                            self.errorSubject.send(error)
                            return Just(false)
                        }
                        .eraseToAnyPublisher()
                }

                return Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            isBottomButtonEnabled: isBottomButtonEnabled,
            bottomButtonResult: bottomButtonResult
        )
    }
}

// MARK: - Public Methods

public extension CollegeInfoViewModel {
    func selectItem(_ item: CollegesInfoModel) {
        if selectedItemForUI == item {
            selectedItemForUI = nil
            selectedCollegeSubject.send(nil)
        } else {
            selectedItemForUI = item
            selectedCollegeSubject.send(item.id)
        }
    }
}

// MARK: - Private API methods

private extension CollegeInfoViewModel {
    func fetchCollegesInfoListPublisher(_ university: String) -> AnyPublisher<[CollegesInfoModel], CollegesError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
                
            Task {
                do {
                    let result = try await self.fetchCollegesInfoListUseCase.execute(universityName: university)
                    promise(.success(result))
                } catch {
                    promise(.failure(.signupFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signupPublisher(_ university: String, _ collegeId: Int) -> AnyPublisher<Void, CollegesError> {
        return Future { [weak self] promise in
            guard let self, let signupUseCase else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    _ = try await signupUseCase.execute(university: university, collgeId: collegeId)
                    promise(.success(()))
                } catch {
                    promise(.failure(.signupFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func editUniversityPublisher(_ university: String) -> AnyPublisher<Void, CollegesError> {
        return Future { [weak self] promise in
            guard let self, let editUniversityUseCase else {
                promise(.failure(.unknown))
                return
            }
            
            if university == UserDefaultsManager.shared.string(for: .university) {
                promise(.failure(.notEditUniversity))
                return
            }
            
            Task {
                do {
                    let _ = try await editUniversityUseCase.execute(university: university)
                    promise(.success(()))
                } catch {
                    promise(.failure(.editUniversityFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
