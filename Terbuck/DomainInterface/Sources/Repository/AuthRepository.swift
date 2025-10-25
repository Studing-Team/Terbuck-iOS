//
//  AuthRepository.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol AuthRepository {
    func serverLoginWithKakao(token: String) async throws -> SocialLoginResultEntity
    func serverLoginWithApple(code: String, name: String) async throws -> SocialLoginResultEntity
    func loginWithAppleService() async throws -> (code: String, name: String)
    func loginWithKakaoService() async throws -> (token: String, username: String)
}