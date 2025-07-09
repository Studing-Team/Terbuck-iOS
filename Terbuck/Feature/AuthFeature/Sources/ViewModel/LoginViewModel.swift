//
//  LoginViewModel.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import Combine
import CoreAppleLogin
import CoreKakaoLogin

import CoreKeyChain
import Shared
import Foundation


enum LoginError: LocalizedError, Equatable {
    case appleLoginFailed
    case serverLoginFailed(reason: String)
    case kakaoLoginFailed
    case saveFcmTokenFailed
    case unknown

    var errorDescription: String {
        switch self {
        case .appleLoginFailed:
            return "애플 로그인을 실패했어요."
        case .serverLoginFailed(let reason):
            return "서버 로그인에 실패했어요: \(reason)"
        case .kakaoLoginFailed:
            return "카카오 로그인을 실패했어요."
        case .saveFcmTokenFailed:
            return "다시 로그인을 시도해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public class LoginViewModel {
    
    // MARK: - Properties
    
    var loginUseCase: SocialLoginUseCase
    var appleServiceLoginUseCase: AppleServiceLoginUseCase
    var kakaoServiceLoginUseCase: KakaoServiceLoginUseCase
    private var searchStudentInfoUseCase: SearchStudentInfoUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Combine Publishers Properties
    
    
    // MARK: - Input
    
    struct Input {
        let appleLoginButtonTapped: AnyPublisher<Void, Never>
        let kakaoLoginButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let loginResult: AnyPublisher<Bool, LoginError>
    }
    
    // MARK: - Init
    
    public init(
        loginUseCase: SocialLoginUseCase,
        appleServiceLoginUseCase: AppleServiceLoginUseCase,
        kakaoServiceLoginUseCase: KakaoServiceLoginUseCase,
        searchStudentInfoUseCase: SearchStudentInfoUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.appleServiceLoginUseCase = appleServiceLoginUseCase
        self.kakaoServiceLoginUseCase = kakaoServiceLoginUseCase
        self.searchStudentInfoUseCase = searchStudentInfoUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let appleResult = input.appleLoginButtonTapped
            .handleEvents(receiveOutput:  { _ in
                MixpanelManager.shared.track(eventType: TrackEventType.Onboarding.appleLogin)
            })
            .flatMap { [weak self] _ -> AnyPublisher<Result<LoginResultModel, LoginError>, Never> in
                guard let self else {
                    return Just(.failure(.unknown))
                        .eraseToAnyPublisher()
                }
                
                return self.appleServiceLoginPublisher()
                    .flatMap { code, name in
                        self.appleServerLoginPublisher(code: code, name: name)
                    }
                    .map { loginResult -> Result<LoginResultModel, LoginError> in
                        return .success(loginResult)
                    }
                    .catch { error -> Just<Result<LoginResultModel, LoginError>> in
                        return Just(.failure(error))
                    }
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { result in
                if case let .success(loginResult) = result {
                    KeychainManager.shared.save(key: .accessToken, value: loginResult.accessToken)
                    KeychainManager.shared.save(key: .refreshToken, value: loginResult.refreshToken)
                    
                    MixpanelManager.shared.setupUser(userId: loginResult.userId)
                }
            })
            .eraseToAnyPublisher()
        
        let kakaoResult = input.kakaoLoginButtonTapped
            .handleEvents(receiveOutput:  { _ in
                MixpanelManager.shared.track(eventType: TrackEventType.Onboarding.kakaoLogin)
            })
            .flatMap { [weak self] _ -> AnyPublisher<Result<LoginResultModel, LoginError>, Never> in
                guard let self else {
                    return Just(.failure(.unknown))
                        .eraseToAnyPublisher()
                 }
        
                return self.kakaoServiceLoginPublisher()
                    .flatMap { token in
                        self.kakaoServerLoginPublisher(token: token)
                    }
                    .map { loginResult -> Result<LoginResultModel, LoginError> in
                        return .success(loginResult)
                    }
                    .catch { error in
                        Just(.failure(error)).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { result in
                if case let .success(loginResult) = result {
                    KeychainManager.shared.save(key: .accessToken, value: loginResult.accessToken)
                    KeychainManager.shared.save(key: .refreshToken, value: loginResult.refreshToken)
                    
                    MixpanelManager.shared.setupUser(userId: loginResult.userId)
                }
            })
            .eraseToAnyPublisher()
        
        let merged = Publishers.Merge(appleResult, kakaoResult)
            .flatMap { [weak self] result -> AnyPublisher<Bool, LoginError> in
                guard let self else {
                    return Fail(error: .unknown).eraseToAnyPublisher()
                }
                
                switch result {
                case .success(let loginResult):
                    let showSignup = loginResult.showSignup
                    
                    return self.postFcmTokenPublisher(showSignup)
                        .map { _ in showSignup } // FCM 성공 시 showSignup 반환
                        .mapError { _ in .saveFcmTokenFailed }
                        .eraseToAnyPublisher()
                    
                case .failure(let error):
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
        
        return Output(
            loginResult: merged
        )
    }
}

// MARK: - Fcm Token Function

private extension LoginViewModel {
    func postFcmTokenPublisher(_ showSignup: Bool) -> AnyPublisher<Bool, LoginError> {
        return Future { [weak self] promise in
            guard let self,
                  let token = KeychainManager.shared.load(key: .fcmToken) else {
                promise(.failure(.appleLoginFailed))
                return
            }

            Task {
                do {
                    try await self.loginUseCase.notificationTokenExecute(token: token)

                    if !showSignup {
                        let studentInfo = try await self.searchStudentInfoUseCase.execute()
                        UserDefaultsManager.shared.set(studentInfo, for: .university)
                    } else {
                        AppLogger.log("회원가입 상태이므로 StudentInfo 가져오기 생략", .debug, .viewModel)
                    }

                    promise(.success(true))
                } catch {
                    promise(.failure(.saveFcmTokenFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Apple Login Function

private extension LoginViewModel {
    func appleServiceLoginPublisher() -> AnyPublisher<(code: String, name: String), LoginError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.appleLoginFailed))
                return
            }
            
            Task {
                do {
                    let result = try await self.appleServiceLoginUseCase.execute()
                    promise(.success(result))
                } catch {
                    promise(.failure(.appleLoginFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func appleServerLoginPublisher(code: String, name: String) -> AnyPublisher<LoginResultModel, LoginError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let loginResult = try await self.loginUseCase.appleLoginExecute(code: code, name: name)
                    promise(.success(loginResult))
                } catch {
                    promise(.failure(.serverLoginFailed(reason: error.localizedDescription)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Kakao Login Function

private extension LoginViewModel {
    func kakaoServiceLoginPublisher() -> AnyPublisher<String, LoginError> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(.kakaoLoginFailed))
                return
            }
            
            Task {
                do {
                    let result = try await self.kakaoServiceLoginUseCase.execute()
                    promise(.success(result))
                } catch {
                    promise(.failure(.kakaoLoginFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func kakaoServerLoginPublisher(token: String) -> AnyPublisher<LoginResultModel, LoginError> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let loginResult = try await self.loginUseCase.kakaoLoginExecute(token: token)
                    promise(.success(loginResult))
                } catch {
                    promise(.failure(.serverLoginFailed(reason: error.localizedDescription)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
