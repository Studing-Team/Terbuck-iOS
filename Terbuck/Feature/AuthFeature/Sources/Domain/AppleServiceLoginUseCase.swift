//
//  AppleLoginUsecase.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public protocol AppleServiceLoginUseCase {
    func execute() async throws -> (code: String, name: String)
}

public struct AppleServiceLoginUseCaseImpl: AppleServiceLoginUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() async throws -> (code: String, name: String) {
        try await repository.loginWithAppleService()
    }
}
