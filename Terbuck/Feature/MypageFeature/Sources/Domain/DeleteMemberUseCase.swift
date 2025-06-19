//
//  DeleteMemberUseCase.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 6/19/25.
//

import Foundation

public protocol DeleteMemberUseCase {
    func execute() async throws -> Void
}

public struct DeleteMemberUseCaseImpl: DeleteMemberUseCase {
    let repository: MemberRepository
    
    public func execute() async throws -> Void {
        try await repository.deleteMember()
    }
}
