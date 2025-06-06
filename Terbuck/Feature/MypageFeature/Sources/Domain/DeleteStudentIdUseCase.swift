//
//  DeleteStudentIdUseCase.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public protocol DeleteStudentIdUseCase {
    func execute() async throws -> Void
}

public struct DeleteStudentIdUseCaseImpl: DeleteStudentIdUseCase {
    let repository: MemberRepository
    
    public func execute() async throws -> Void {
        try await repository.deleteStudentId()
    }
}
