//
//  RequestPartnershipDisclosureUseCase.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 9/2/25.
//

import Foundation

public protocol RequestPartnershipDisclosureUseCase {
    func execute(universityName: String) async throws
}

public struct RequestPartnershipDisclosureUseCaseImpl: RequestPartnershipDisclosureUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }
    
    public func execute(universityName: String) async throws {
        try await repository.postPartnershipDisclosureRequest(universityName: universityName)
    }
}
