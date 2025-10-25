//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import CoreNetwork
import CoreAppleLogin
import CoreKakaoLogin
import DomainInterface

public struct AuthRepositoryImpl: AuthRepository {
    
    private let networkManager = NetworkManager.shared
    private let appleLoginService = AppleLoginService.shared
    private let kakaoLoginService = KakaoLoginService.shared
    
    public init() {}
    
    // MARK: - Server Login
    
    public func serverLoginWithKakao(token: String) async throws -> SocialLoginResultEntity {
        let requestDTO = KakaoLoginRequestDTO(token: token)
        let dto: SocialLoginResponseDTO = try await networkManager.request(AuthAPIEndpoint.postAuthKakao(requestDTO))
        return dto.toEntity()
    }
    
    public func serverLoginWithApple(code: String, name: String) async throws -> SocialLoginResultEntity {
        let requestDTO = AppleLoginRequestDTO(code: code, name: name)
        let dto: SocialLoginResponseDTO = try await networkManager.request(AuthAPIEndpoint.postAuthApple(requestDTO))
        return dto.toEntity()
    }
    
    // MARK: - Service Login
    
    public func loginWithKakaoService() async throws -> (token: String, username: String) {
        let result = try await kakaoLoginService.login()
        return (token: result.0, username: result.1 ?? "")
    }
    
    public func loginWithAppleService() async throws -> (code: String, name: String) {
        return try await appleLoginService.login()
    }
}
