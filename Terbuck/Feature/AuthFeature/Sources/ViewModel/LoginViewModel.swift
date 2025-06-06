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
import Foundation


enum LoginError: LocalizedError, Equatable {
    case appleLoginFailed
    case serverLoginFailed(reason: String)
    case kakaoLoginFailed
    case unknown

    var errorDescription: String {
        switch self {
        case .appleLoginFailed:
            return "애플 로그인을 실패했어요."
        case .serverLoginFailed(let reason):
            return "서버 로그인에 실패했어요: \(reason)"
        case .kakaoLoginFailed:
            return "카카오 로그인을 실패했어요."
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
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Combine Publishers Properties
    
    
    // MARK: - Input
    
    struct Input {
        let appleLoginButtonTapped: AnyPublisher<Void, Never>
        let kakaoLoginButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let loginResult: AnyPublisher<Result<Bool, LoginError>, Never>
    }
    
    // MARK: - Init
    
    public init(
        loginUseCase: SocialLoginUseCase,
        appleServiceLoginUseCase: AppleServiceLoginUseCase,
        kakaoServiceLoginUseCase: KakaoServiceLoginUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.appleServiceLoginUseCase = appleServiceLoginUseCase
        self.kakaoServiceLoginUseCase = kakaoServiceLoginUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let appleResult = input.appleLoginButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Result<LoginResultModel, LoginError>, Never> in
                guard let self else {
                    return Just(.failure(.unknown))
                        .eraseToAnyPublisher()
                }
                
                return self.appleServiceLoginPublisher()
                    .flatMap { code, name in
                        self.appleServerLoginPublisher(code: code, name: name)
                    }
                    .catch { error in
                        Just(.failure(error))
                            .eraseToAnyPublisher()
                    }
                    .handleEvents(receiveOutput: { result in
                        if case let .success(loginResult) = result {
                            KeychainManager.shared.save(key: .accessToken, value: loginResult.accessToken)
                            KeychainManager.shared.save(key: .refreshToken, value: loginResult.refreshToken)
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let kakaoResult = input.kakaoLoginButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Result<LoginResultModel, LoginError>, Never> in
                guard let self else {
                    return Just(.failure(.unknown))
                        .eraseToAnyPublisher()
                 }
        
                return self.kakaoServiceLoginPublisher()
                    .flatMap { token in
                        self.kakaoServerLoginPublisher(token: token)
                    }
                    .catch { error in
                        Just(.failure(error)).eraseToAnyPublisher()
                    }
                    .handleEvents(receiveOutput: { result in
                        if case let .success(loginResult) = result {
                            KeychainManager.shared.save(key: .accessToken, value: loginResult.accessToken)
                            KeychainManager.shared.save(key: .refreshToken, value: loginResult.refreshToken)
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let merged = Publishers.Merge(appleResult, kakaoResult)
            .map { result -> Result<Bool, LoginError> in
                result.map { $0.showSignup }
            }
            .eraseToAnyPublisher()
        
        return Output(
            loginResult: merged
        )
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
    
    func appleServerLoginPublisher(code: String, name: String) -> AnyPublisher<Result<LoginResultModel, LoginError>, Never> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.success(.failure(.unknown)))
                return
            }
            
            Task {
                do {
                    let loginResult = try await self.loginUseCase.appleLoginExecute(code: code, name: name)
                    promise(.success(.success(loginResult)))
                } catch {
                    promise(.success(.failure(.serverLoginFailed(reason: ""))))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Kakao Login Function

private extension LoginViewModel {
    func kakaoServiceLoginPublisher() -> AnyPublisher<String, LoginError> {
        print("kakaoServiceLoginPublisher 실행")
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(.kakaoLoginFailed))
                return
            }
            
            Task {
                do {
                    let result = try await self.kakaoServiceLoginUseCase.execute()
                    print("결괏값:", result)
                    promise(.success(result))
                } catch {
                    promise(.failure(.kakaoLoginFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func kakaoServerLoginPublisher(token: String) -> AnyPublisher<Result<LoginResultModel, LoginError>, Never> {
        print("kakaoServerLoginPublisher 실행")
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.success(.failure(.unknown)))
                return
            }
            
            Task {
                do {
                    let loginResult = try await self.loginUseCase.kakaoLoginExecute(token: token)
                    promise(.success(.success(loginResult)))
                } catch {
                    promise(.success(.failure(.serverLoginFailed(reason: ""))))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
