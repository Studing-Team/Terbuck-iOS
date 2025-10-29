//
//  DeleteStudentIdUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import DomainInterface

public struct DeleteStudentIdUseCaseImpl: DeleteStudentIdUseCase {
    private let repository: any MemberRepository
    
    public init(repository: any MemberRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> Void {
        try await repository.deleteStudentId()
    }
}