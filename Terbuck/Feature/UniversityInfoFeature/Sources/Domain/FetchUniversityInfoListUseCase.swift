//
//  FetchUniversityInfoListUseCase.swift
//  RegisterStudentCardFeature
//
//  Created by ParkJunHyuk on 9/4/25.
//

import Foundation

public protocol FetchUniversityInfoListUseCase {
    func execute() async throws -> [UniversityInfoModel]
}

public struct FetchUniversityInfoListUseCaseImpl: FetchUniversityInfoListUseCase {
    let repository: UniversityRepository
    
    public init(repository: UniversityRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [UniversityInfoModel] {
        let entity = try await repository.getUniversityInfoList()
        
        return convertToModel(entity)
    }
}

extension FetchUniversityInfoListUseCaseImpl {
    func convertToModel(_ entity: [UniversityInfoEntity]) -> [UniversityInfoModel] {
        return entity.map {
            UniversityInfoModel(
                id: $0.id,
                title: $0.regionName,
                items: $0.universityNames
            )
        }
    }
}
