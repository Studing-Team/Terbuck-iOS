//
//  GetCollegesInfoListUseCaseImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

public struct GetCollegesInfoListUseCaseImpl: GetCollegesInfoListUseCase {
    private let universityRepository: any UniversityRepository
    
    public init(universityRepository: any UniversityRepository) {
        self.universityRepository = universityRepository
    }
    
    public func execute(university: String) async throws -> [CollegesInfoEntity] {
        return try await universityRepository.getCollegesInfoList(university: university)
    }
}