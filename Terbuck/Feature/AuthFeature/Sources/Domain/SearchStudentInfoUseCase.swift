//
//  SearchStudentInfoUseCase.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 6/29/25.
//

import Foundation
import Shared

public protocol SearchStudentInfoUseCase {
    func execute() async throws -> String
}

public struct SearchStudentInfoUseCaseImpl: SearchStudentInfoUseCase {
    let repository: AuthRepository
    
    public func execute() async throws -> String {
        let entity = try await repository.getStudentInfo()
        
        return entity.universityName
    }
}
