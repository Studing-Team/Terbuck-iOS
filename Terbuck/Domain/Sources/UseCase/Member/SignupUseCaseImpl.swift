//
//  SignupUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

public struct SignupUseCaseImpl: SignupUseCase {
    private let memberRepository: any MemberRepository
    
    public init(memberRepository: any MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func execute(university: String, collegeId: Int) async throws -> Void {
        try await memberRepository.postSignupMember(university: university, collegeId: collegeId)
    }
}