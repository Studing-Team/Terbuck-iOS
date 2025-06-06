//
//  SignupUseCase.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/26/25.
//

import Foundation

public protocol SignupUseCase {
    func execute(university: String) async throws -> Void
}

public struct SignupUseCaseImpl: SignupUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(university: String) async throws -> Void {
        try await repository.postSignupMember(university: university)
    }
}
