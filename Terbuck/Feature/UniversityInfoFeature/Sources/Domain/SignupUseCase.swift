//
//  SignupUseCase.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import Foundation
import CoreNetwork

public protocol SignupUseCase {
    func execute(university: String) async throws -> Void
}

public struct SignupUseCaseImpl: SignupUseCase {
    private let repository: UniversityRepository

    public init(repository: UniversityRepository) {
        self.repository = repository
    }

    public func execute(university: String) async throws -> Void {
        try await repository.postSignupMember(university: university)
    }
}
