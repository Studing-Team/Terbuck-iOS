//
//  SearchStudentInfoUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface

public struct SearchStudentInfoUseCaseImpl: SearchStudentInfoUseCase {
    let memberRepository: MemberRepository
    
    public init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func execute() async throws -> SearchStudentInfoEntity {
        return try await memberRepository.getStudentInfo()
    }
}
