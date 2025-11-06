//
//  GetUniversityInfoListUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

public struct GetUniversityInfoListUseCaseFactoryImpl: GetUniversityInfoListUseCaseFactory {
    private let universityRepository: any UniversityRepository
    
    public init(universityRepository: any UniversityRepository) {
        self.universityRepository = universityRepository
    }
    
    public func makeGetUniversityInfoListUseCase() -> any GetUniversityInfoListUseCase {
        return GetUniversityInfoListUseCaseImpl(universityRepository: universityRepository)
    }
}