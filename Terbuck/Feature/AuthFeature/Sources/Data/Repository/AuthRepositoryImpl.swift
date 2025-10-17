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
    func loginWithKakaoService() async throws -> (token: String, username: String)
    func postNotificationToken(token: String) async throws
    func getStudentInfo() async throws -> SearchStudentInfoEntity
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
    
    func loginWithKakaoService() async throws -> (token: String, username: String) {
        let result = try await kakaoLoginService.login()
        return (token: result.0, username: result.1 ?? "")
    }
    
    func loginWithAppleService() async throws -> (code: String, name: String) {
        return try await appleLoginService.login()
    }
    
    func postNotificationToken(token: String) async throws {
        let requestDTO = NotificationTokenRequestDTO(deviceToken: token)
        
        let _: EmptyResponseDTO = try await networkManager.request(AuthAPIEndpoint.postNotificationToken(requestDTO))
    }
    
    func getStudentInfo() async throws -> SearchStudentInfoEntity {
        let dto: SearchStudentInfoResponseDTO = try await networkManager.request(MemberAPIEndpoint.getStudentId)
        return dto.toEntity()
    }
}
