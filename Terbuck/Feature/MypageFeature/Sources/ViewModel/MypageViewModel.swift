//
//  MypageViewModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import Foundation
import Combine

import CoreKeyChain
import Shared
import DesignSystem

enum MypageError: LocalizedError, Equatable {
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

public final class MypageViewModel {
    
    // MARK: - Properties
    
    private var searchStudentInfoUseCase: SearchStudentInfoUseCase
    
    // MARK: - Private Combine Publishers Properties
    
    private let navigationEventSubject = PassthroughSubject<MypageNavigationType, Never>()
    private let searchStudentInfoErrorSubject = PassthroughSubject<MypageError, Never>()
    private let toasterMessageSubject = PassthroughSubject<ToastType, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Combine Publishers Properties
    
    var searchStudentInfoError: AnyPublisher<MypageError, Never> {
        searchStudentInfoErrorSubject.eraseToAnyPublisher()
    }
    
    let userInfoModelSubject = CurrentValueSubject<UserInfoModel?, Never>(nil)
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let selectedCell: AnyPublisher<(section: MyPageType, index: Int), Never>
        let logoutButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let searchStudentInfoResult: AnyPublisher<Void, Never>
        let navigationEvent: AnyPublisher<MypageNavigationType, Never>
        let logoutResult: AnyPublisher<Bool, Never>
        let searchStudentInfoError: AnyPublisher<MypageError, Never>
        let toasterMessageResult: AnyPublisher<ToastType, Never>
    }
    
    // MARK: - Init
    
    public init(
        searchStudentInfoUseCase: SearchStudentInfoUseCase
    ) {
        self.searchStudentInfoUseCase = searchStudentInfoUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let searchResult = input.viewLifeCycleEventAction
            .flatMap { [weak self] event -> AnyPublisher<Void, Never> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                switch event {
                case .viewDidLoad:
                    return self.performSearchMyInfo()
                    
                case .viewWillAppear:
                    let savedUniversityName = UserDefaultsManager.shared.string(for: .university)
                    let currentUniversityName = self.userInfoModelSubject.value?.university

                    guard let currentUniversityName else { return Empty().eraseToAnyPublisher() }
                    
                    if savedUniversityName != currentUniversityName {
                        toasterMessageSubject.send(.changeUniversity)
                        
                        return self.performSearchMyInfo()
                    } else {
                        return Empty().eraseToAnyPublisher()
                    }
                }
            }
            .eraseToAnyPublisher()
        
        input.selectedCell
            .sink { [weak self] section, index in
                guard let self else { return }
                
                self.selectCellHandler(section: section, index: index)
            }
            .store(in: &cancellables)
        
        let logoutResult = input.logoutButtonTapped
            .map { _ -> Bool in
                KeychainManager.shared.clearTokens()
                FileStorageManager.shared.delete(type: .studentIdCard)
                UserDefaultsManager.shared.remove(.isStudentIDAuthenticated)
                UserDefaultsManager.shared.remove(.university)
                
                return true
            }
        
        return Output(
            searchStudentInfoResult: searchResult.eraseToAnyPublisher(),
            navigationEvent: navigationEventSubject.eraseToAnyPublisher(),
            logoutResult: logoutResult.eraseToAnyPublisher(),
            searchStudentInfoError: searchStudentInfoError,
            toasterMessageResult: toasterMessageSubject.eraseToAnyPublisher()
        )
    }
}

// MARK: - Private API Extension

private extension MypageViewModel {
    func searchMyInfoPublisher() -> AnyPublisher<UserInfoModel, MypageError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let result = try await self.searchStudentInfoUseCase.execute()
                    UserDefaultsManager.shared.set(result.isAuthenticated, for: .isStudentIDAuthenticated)
                    promise(.success(result))
                } catch {
                    promise(.failure(.studentInfoFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Private Methods Extension

private extension MypageViewModel {
    func performSearchMyInfo() -> AnyPublisher<Void, Never> {
        return searchMyInfoPublisher()
            .handleEvents(receiveOutput: { [weak self] model in
                self?.userInfoModelSubject.send(model)
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.searchStudentInfoErrorSubject.send(error)
                }
            })
            .map { _ in () }
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }
    
    func selectCellHandler(section: MyPageType, index: Int) {
        switch section {
        case .userInfo:
            break

        case .alarmSetting:
            navigationEventSubject.send(.alarmSetting)

        case .appService:
            switch index {
            case 0: navigationEventSubject.send(.inquiry)
            case 1: navigationEventSubject.send(.serviceGuide)
            case 2: navigationEventSubject.send(.privacyPolicy)
            default: break
            }

        case .userAuth:
            switch index {
            case 0: navigationEventSubject.send(.showLogout)
            case 1: navigationEventSubject.send(.withdraw)
            default: break
            }
        }
    }
    
    func saveStudentIdImage(imageData: Data) {
        let isStudentId = FileStorageManager.shared.exists(type: .studentIdCard)
        
        if isStudentId {
            FileStorageManager.shared.delete(type: .studentIdCard)
        }
        
        let _ = FileStorageManager.shared.save(data: imageData, type: .studentIdCard)
    }
}
