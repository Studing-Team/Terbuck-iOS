//
//  SearchStudentInfoUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface

public struct SearchStudentInfoUseCaseImpl: DomainInterface.SearchStudentInfoUseCase {
    let memberRepository: DomainInterface.MemberRepository
    
    public init(memberRepository: DomainInterface.MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func execute() async throws -> String {
        let entity = try await memberRepository.getStudentInfo()
        
        return entity.universityName
    }
}
