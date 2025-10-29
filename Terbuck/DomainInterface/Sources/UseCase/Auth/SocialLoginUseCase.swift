//
//  SocialLoginUseCase.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol SocialLoginUseCase {
    func appleLoginExecute(code: String, name: String) async throws -> LoginResultEntity
    func kakaoLoginExecute(token: String) async throws -> LoginResultEntity
    func notificationTokenExecute(token: String) async throws
}
