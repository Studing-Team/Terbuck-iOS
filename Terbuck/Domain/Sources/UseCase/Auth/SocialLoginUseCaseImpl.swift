//
//  SocialLoginUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface

public struct SocialLoginUseCaseImpl: SocialLoginUseCase {
    let authRepository: AuthRepository
    let notificationRepository: NotificationRepository
    
    public init(authRepository: AuthRepository, notificationRepository: NotificationRepository) {
        self.authRepository = authRepository
        self.notificationRepository = notificationRepository
    }
    
    public func appleLoginExecute(code: String, name: String) async throws -> LoginResultEntity {
        let entity = try await authRepository.serverLoginWithApple(code: code, name: name)
        
        return LoginResultEntity(
            showSignup: entity.showSignup,
            userId: entity.id,
            accessToken: entity.accessToken,
            refreshToken: entity.refreshToken
        )
    }
    
    public func kakaoLoginExecute(token: String) async throws -> LoginResultEntity {
        let entity = try await authRepository.serverLoginWithKakao(token: token)
        
        return LoginResultEntity(
            showSignup: entity.showSignup,
            userId: entity.id,
            accessToken: entity.accessToken,
            refreshToken: entity.refreshToken
        )
    }
    
    public func notificationTokenExecute(token: String) async throws {
        let _ = try await notificationRepository.postNotificationToken(token: token)
    }
}
