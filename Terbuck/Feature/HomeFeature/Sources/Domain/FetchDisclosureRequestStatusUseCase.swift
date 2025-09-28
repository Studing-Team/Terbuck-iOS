//
//  FetchDisclosureRequestStatusUseCase.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 9/2/25.
//

import Foundation

public protocol FetchDisclosureRequestStatusUseCase {
    func execute(universityName: String) async throws -> Bool
}

public struct FetchDisclosureRequestStatusUseCaseImpl: FetchDisclosureRequestStatusUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }
    
    public func execute(universityName: String) async throws -> Bool {
        return try await repository.getDisclosureRequestStatus(universityName: universityName)
    }
}
