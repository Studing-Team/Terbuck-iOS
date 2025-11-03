//
//  UpdateUniversityUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

public struct UpdateUniversityUseCaseFactoryImpl: UpdateUniversityUseCaseFactory {
    private let memberRepository: any MemberRepository
    
    public init(memberRepository: any MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    public func makeUpdateUniversityUseCase() -> any UpdateUniversityUseCase {
        return UpdateUniversityUseCaseImpl(memberRepository: memberRepository)
    }
}