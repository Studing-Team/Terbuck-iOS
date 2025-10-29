//
//  RegisterStudentIdUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import DomainInterface

public struct RegisterStudentIdUseCaseImpl: RegisterStudentIdUseCase {
    private let repository: any MemberRepository
    
    public init(repository: any MemberRepository) {
        self.repository = repository
    }
    
    public func execute(
        idCardImage: Data,
        name: String,
        studentNumber: String
    ) async throws -> Void {
        try await repository.putRegisterStudentId(
            idCardImage: idCardImage,
            name: name,
            studentNumber: studentNumber
        )
    }
}
