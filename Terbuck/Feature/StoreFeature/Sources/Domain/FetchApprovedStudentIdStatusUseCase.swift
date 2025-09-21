//
//  FetchApprovedStudentIdStatusUseCase.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 9/20/25.
//

import Foundation
import Shared

public protocol FetchApprovedStudentIdStatusUseCase {
    func execute() async throws -> Bool
}

public struct FetchApprovedStudentIdStatusUseCaseImpl: FetchApprovedStudentIdStatusUseCase {
    private let repository: StoreRepository

    public init(repository: StoreRepository) {
        self.repository = repository
    }

    public func execute() async throws -> Bool {
        return try await repository.getApprovedStudentIdStatus()
    }
}
