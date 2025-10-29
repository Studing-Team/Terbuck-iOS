//
//  RegisterStudentIdUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import DomainInterface

public struct RegisterStudentIdUseCaseFactoryImpl: RegisterStudentIdUseCaseFactory {
    private let memberRepository: any MemberRepository
    
    public init(memberRepository: any MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func makeRegisterStudentIdUseCase() -> any RegisterStudentIdUseCase {
        return RegisterStudentIdUseCaseImpl(repository: memberRepository)
    }
}