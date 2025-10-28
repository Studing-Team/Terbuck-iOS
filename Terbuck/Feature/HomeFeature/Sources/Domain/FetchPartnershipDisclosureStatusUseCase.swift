//
//  FetchPartnershipDisclosureStatusUseCase.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 9/2/25.
//

import Foundation

public protocol FetchPartnershipDisclosureStatusUseCase {
    func execute(universityName: String) async throws -> Bool
}

public struct FetchPartnershipDisclosureStatusUseCaseImpl: FetchPartnershipDisclosureStatusUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }
    
    public func execute(universityName: String) async throws -> Bool {
        return try await repository.getPartnershipDisclosureStatus(universityName: universityName)
    }
}
