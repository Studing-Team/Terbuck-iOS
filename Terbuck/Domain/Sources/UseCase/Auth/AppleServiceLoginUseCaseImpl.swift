//
//  AppleServiceLoginUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface

public struct AppleServiceLoginUseCaseImpl: AppleServiceLoginUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() async throws -> (code: String, name: String) {
        try await repository.loginWithAppleService()
    }
}
