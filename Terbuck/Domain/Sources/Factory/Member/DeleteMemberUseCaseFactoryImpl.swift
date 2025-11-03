//
//  DeleteMemberUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 6/19/25.
//

import Foundation
import DomainInterface

public struct DeleteMemberUseCaseFactoryImpl: DeleteMemberUseCaseFactory {
    private let memberRepository: any MemberRepository
    
    public init(memberRepository: any MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func makeDeleteMemberUseCase() -> any DeleteMemberUseCase {
        return DeleteMemberUseCaseImpl(repository: memberRepository)
    }
}
