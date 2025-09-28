//
//  SearchStudentInfoUseCase.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 9/26/25.
//

import Foundation
import Shared

public protocol SearchStudentInfoUseCase {
    func execute() async throws -> SearchStudentInfoEntity
}

public struct SearchStudentInfoUseCaseImpl: SearchStudentInfoUseCase {
    let repository: SplashRepository
    
    public func execute() async throws -> SearchStudentInfoEntity {
        return try await repository.getStudentInfo()
    }
}
