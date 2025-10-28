//
//  AppleServiceLoginUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface

public struct AppleServiceLoginUseCaseImpl: DomainInterface.AppleServiceLoginUseCase {
    private let repository: DomainInterface.AuthRepository

    public init(repository: DomainInterface.AuthRepository) {
        self.repository = repository
    }

    public func execute() async throws -> (code: String, name: String) {
        try await repository.loginWithAppleService()
    }
}
