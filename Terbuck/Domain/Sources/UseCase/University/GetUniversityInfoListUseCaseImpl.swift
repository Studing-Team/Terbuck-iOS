//
//  GetUniversityInfoListUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

public struct GetUniversityInfoListUseCaseImpl: GetUniversityInfoListUseCase {
    private let universityRepository: any UniversityRepository
    
    public init(universityRepository: any UniversityRepository) {
        self.universityRepository = universityRepository
    }
    
    public func execute() async throws -> [UniversityInfoEntity] {
        return try await universityRepository.getUniversityInfoList()
    }
}