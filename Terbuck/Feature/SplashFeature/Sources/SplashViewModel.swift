//
//  SplashViewModel.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 9/26/25.
//

import Foundation
import Combine

import CoreKeyChain
import Shared

enum SplashError: LocalizedError, Equatable {
    case serverFailed
    case versionFailed
    case unknown
    
    var errorDescription: String {
        switch self {
        case .serverFailed:
            return "다시 시도해주세요."
        case .versionFailed:
            return "버전을 불러올 수 없습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public enum SplashAction {
    case goToLogin
    case goToMain
    case needsUpdate
}

public class SplashViewModel {
    
    // MARK: - Properties
    
    private var searchStudentInfoUseCase: SearchStudentInfoUseCase
    private var fetchCheckUpdateStateUseCase: FetchCheckUpdateStateUseCase
    
    // MARK: - Private Combine Publishers Properties
    
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let splashAction: AnyPublisher<SplashAction, Never>
    }
    
    // MARK: - Init
    
    init(
        searchStudentInfoUseCase: SearchStudentInfoUseCase,
        fetchCheckUpdateStateUseCase: FetchCheckUpdateStateUseCase
    ) {
        self.searchStudentInfoUseCase = searchStudentInfoUseCase
        self.fetchCheckUpdateStateUseCase = fetchCheckUpdateStateUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let splashAction = input.viewLifeCycleEventAction
            .filter { $0 == .viewDidLoad }
            .flatMap { [weak self] _ -> AnyPublisher<SplashAction, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                if KeychainManager.shared.load(key: .accessToken) == nil {
                    return Just(.goToLogin).eraseToAnyPublisher()
                }
                
                // 1. 두 퍼블리셔를 가져옵니다.
                let updatePublisher = self.fetchCheckUpdateStatePublisher()
                let infoPublisher = self.fetchSearchMyInfoPublisher()

                // 2. Publishers.Zip으로 두 퍼블리셔를 동시에 실행하고 결과를 묶습니다.
                return Publishers.Zip(updatePublisher, infoPublisher)
                    .map { (isUpdateRequired, info) -> SplashAction in
                        // 3. 두 작업이 모두 성공했을 때의 로직
                        if isUpdateRequired {
                            return .needsUpdate
                        } else {
                            UserDefaultsManager.shared.set(info.isAuth, for: .isStudentIDAuthenticated)
                            UserDefaultsManager.shared.set(info.universityName, for: .university)
                            
                            if let imageURL = info.imageUrl {
                                UserDefaultsManager.shared.set(imageURL, for: .studentIdCardImageURL)
                            }
                            
                            return .goToMain
                        }
                    }
                    .catch { error -> Just<SplashAction> in
                        return Just(.goToLogin)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            
        return Output(splashAction: splashAction)
    }
}

// MARK: - Private Extension

private extension SplashViewModel {
    func getAppVersion() -> String? {
        guard let dictionary = Bundle.main.infoDictionary else { return nil }
        
        let version = dictionary["CFBundleShortVersionString"] as? String
        
        return version
    }
}

// MARK: - Private API Func Extension

private extension SplashViewModel {
    func fetchCheckUpdateStatePublisher() -> AnyPublisher<Bool, SplashError> {
        return Future { [weak self] promise in
            guard let self, let version = getAppVersion() else {
                promise(.failure(.versionFailed))
                return
            }
            
            Task {
                do {
                    let result = try await self.fetchCheckUpdateStateUseCase.execute(version: version)
                    promise(.success(result))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchSearchMyInfoPublisher() -> AnyPublisher<SearchStudentInfoEntity, SplashError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let result = try await self.searchStudentInfoUseCase.execute()
                    promise(.success(result))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
