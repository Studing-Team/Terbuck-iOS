//
//  AuthRepositoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation
import CoreNetwork
import CoreAppleLogin
import CoreKakaoLogin

public protocol AuthRepository {
    func serverLoginWithKakao(token: String) async throws -> SocialLoginResultEntity
    func serverLoginWithApple(code: String, name: String) async throws -> SocialLoginResultEntity
    func loginWithAppleService() async throws -> (code: String, name: String)
    func loginWithKakaoService() async throws -> String
    func postNotificationToken(token: String) async throws
}

struct AuthRepositoryImpl: AuthRepository {
    
    // MARK: - Property
    
    private let networkManager = NetworkManager.shared
    private let appleLoginService = AppleLoginService.shared
    private let kakaoLoginService = KakaoLoginService.shared
    
    // MARK: - Server Function
    
    func serverLoginWithKakao(token: String) async throws -> SocialLoginResultEntity {
        let requestDTO = KakaoLoginRequestDTO(token: token)
        
        let dto: SocialLoginResponseDTO = try await networkManager.request(AuthAPIEndpoint.postAuthKakao(requestDTO))
        return dto.toEntity()
    }
    
    func serverLoginWithApple(code: String, name: String) async throws -> SocialLoginResultEntity {
        let requestDTO = AppleLoginRequestDTO(code: code, name: name)
        
        let dto: SocialLoginResponseDTO = try await networkManager.request(AuthAPIEndpoint.postAuthApple(requestDTO))
        return dto.toEntity()
    }
    
    // MARK: - Service Function
    
    func loginWithKakaoService() async throws -> String {
        return try await kakaoLoginService.login()
    }
    
    func loginWithAppleService() async throws -> (code: String, name: String) {
        return try await appleLoginService.login()
    }
    
    func postNotificationToken(token: String) async throws {
        let requestDTO = NotificationTokenRequestDTO(deviceToken: token)
        
        let _: EmptyResponseDTO = try await networkManager.request(AuthAPIEndpoint.postNotificationToken(requestDTO))
    }
}
