//
//  SearchStudentInfoUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface

public struct SearchStudentInfoUseCaseFactoryImpl: SearchStudentInfoUseCaseFactory {
    private let memberRepository: any MemberRepository
    
    public init(memberRepository: any MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func makeSearchStudentInfoUseCase() -> any SearchStudentInfoUseCase {
        return SearchStudentInfoUseCaseImpl(memberRepository: memberRepository)
    }
}
