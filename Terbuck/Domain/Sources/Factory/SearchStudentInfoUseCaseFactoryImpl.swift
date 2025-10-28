//
//  SearchStudentInfoUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface
import Data

public struct SearchStudentInfoUseCaseFactoryImpl: SearchStudentInfoUseCaseFactory {
    public init() {}
    
    public func makeSearchStudentInfoUseCase() -> any SearchStudentInfoUseCase {
        let memberRepository = MemberRepositoryImpl()
        return SearchStudentInfoUseCaseImpl(memberRepository: memberRepository)
    }
}