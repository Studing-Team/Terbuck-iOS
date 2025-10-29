//
//  DeleteStudentIdUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import DomainInterface

public struct DeleteStudentIdUseCaseFactoryImpl: DeleteStudentIdUseCaseFactory {
    private let memberRepository: any MemberRepository
    
    public init(memberRepository: any MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func makeDeleteStudentIdUseCase() -> any DeleteStudentIdUseCase {
        return DeleteStudentIdUseCaseImpl(repository: memberRepository)
    }
}