//
//  EditUniversityUseCase.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import Foundation
import CoreNetwork

public protocol EditUniversityUseCase {
    func execute(university: String) async throws -> Void
}

public struct EditUniversityUseCaseImpl: EditUniversityUseCase {
    private let repository: UniversityRepository

    public init(repository: UniversityRepository) {
        self.repository = repository
    }

    public func execute(university: String) async throws -> Void {
        try await repository.patchUniversityInfo(university: university)
    }
}
