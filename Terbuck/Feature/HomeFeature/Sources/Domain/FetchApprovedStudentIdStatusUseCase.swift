//
//  FetchApprovedStudentIdStatusUseCase.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 9/19/25.
//

import Foundation
import Shared

public protocol FetchApprovedStudentIdStatusUseCase {
    func execute() async throws -> Bool
}

public struct FetchApprovedStudentIdStatusUseCaseImpl: FetchApprovedStudentIdStatusUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute() async throws -> Bool {
        return try await repository.getApprovedStudentIdStatus()
    }
}
