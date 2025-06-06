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
}

public struct SocialLoginUseCaseImpl: SocialLoginUseCase {
    let repository: AuthRepository
    
    public func appleLoginExecute(code: String, name: String) async throws -> LoginResultModel {
        let entity = try await repository.serverLoginWithApple(code: code, name: name)
        
        return LoginResultModel(
            showSignup: entity.showSignup,
            accessToken: entity.accessToken,
            refreshToken: entity.refreshToken
        )
    }
    
    public func kakaoLoginExecute(token: String) async throws -> LoginResultModel {
        let entity = try await repository.serverLoginWithKakao(token: token)
        
        return LoginResultModel(
            showSignup: entity.showSignup,
            accessToken: entity.accessToken,
            refreshToken: entity.refreshToken
        )
    }
}
