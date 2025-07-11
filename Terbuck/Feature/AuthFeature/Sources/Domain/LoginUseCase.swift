//
//  LoginUseCase.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public protocol SocialLoginUseCase {
    func appleLoginExecute(code: String, name: String) async throws -> LoginResultModel
    func kakaoLoginExecute(token: String) async throws -> LoginResultModel
    func notificationTokenExecute(token: String) async throws
}

public struct SocialLoginUseCaseImpl: SocialLoginUseCase {
    let repository: AuthRepository
    
    public func appleLoginExecute(code: String, name: String) async throws -> LoginResultModel {
        let entity = try await repository.serverLoginWithApple(code: code, name: name)
        
        return LoginResultModel(
            showSignup: entity.showSignup,
            userId: entity.id,
            accessToken: entity.accessToken,
            refreshToken: entity.refreshToken
        )
    }
    
    public func kakaoLoginExecute(token: String) async throws -> LoginResultModel {
        let entity = try await repository.serverLoginWithKakao(token: token)
        
        return LoginResultModel(
            showSignup: entity.showSignup,
            userId: entity.id,
            accessToken: entity.accessToken,
            refreshToken: entity.refreshToken
        )
    }
    
    public func notificationTokenExecute(token: String) async throws {
        let _ = try await repository.postNotificationToken(token: token)
    }
}
