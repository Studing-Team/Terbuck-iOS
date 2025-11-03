//
//  SignupUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

public struct SignupUseCaseFactoryImpl: SignupUseCaseFactory {
    private let memberRepository: any MemberRepository
    
    public init(memberRepository: any MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func makeSignupUseCase() -> any SignupUseCase {
        return SignupUseCaseImpl(memberRepository: memberRepository)
    }
}