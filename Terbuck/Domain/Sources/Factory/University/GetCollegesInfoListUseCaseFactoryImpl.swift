//
//  GetCollegesInfoListUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

public struct GetCollegesInfoListUseCaseFactoryImpl: GetCollegesInfoListUseCaseFactory {
    private let universityRepository: any UniversityRepository
    
    public init(universityRepository: any UniversityRepository) {
        self.universityRepository = universityRepository
    }
    
    public func makeGetCollegesInfoListUseCase() -> any GetCollegesInfoListUseCase {
        return GetCollegesInfoListUseCaseImpl(universityRepository: universityRepository)
    }
}