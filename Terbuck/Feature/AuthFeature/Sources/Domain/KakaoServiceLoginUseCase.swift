//
//  KakaoServiceLoginUseCase.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/26/25.
//

import Foundation

public protocol KakaoServiceLoginUseCase {
    func execute() async throws -> String
}

public struct KakaoServiceLoginUseCaseImpl: KakaoServiceLoginUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() async throws -> String {
        try await repository.loginWithKakaoService()
    }
}
