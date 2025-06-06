//
//  ChangeUniversityUseCase.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public protocol ChangeUniversityUseCase {
    func execute(university: String) async throws -> Void
}

public struct ChangeUniversityUseCaseImpl: ChangeUniversityUseCase {
    let repository: MemberRepository
    
    public func execute(university: String) async throws -> Void {
        try await repository.patchUniversityInfo(university: university)
    }
}
