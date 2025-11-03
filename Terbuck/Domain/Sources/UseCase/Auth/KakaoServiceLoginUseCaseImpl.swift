//
//  KakaoServiceLoginUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface

public struct KakaoServiceLoginUseCaseImpl: KakaoServiceLoginUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() async throws -> (token: String, user: String) {
        let result = try await repository.loginWithKakaoService()
        
        return (token: result.token, user: result.username)
    }
}
