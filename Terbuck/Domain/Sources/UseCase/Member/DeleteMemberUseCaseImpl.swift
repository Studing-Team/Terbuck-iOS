//
//  DeleteMemberUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 6/19/25.
//

import Foundation
import DomainInterface

public struct DeleteMemberUseCaseImpl: DeleteMemberUseCase {
    private let repository: any MemberRepository
    
    public init(repository: any MemberRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> Void {
        try await repository.deleteMember()
    }
}
