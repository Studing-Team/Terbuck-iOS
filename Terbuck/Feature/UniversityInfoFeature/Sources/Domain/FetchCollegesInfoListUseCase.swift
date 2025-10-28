//
//  FetchCollegesInfoListUseCase.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 9/23/25.
//

import Foundation
import Shared

public protocol FetchCollegesInfoListUseCase {
    func execute(universityName: String) async throws -> [CollegesInfoModel]
}

public struct FetchCollegesInfoListUseCaseImpl: FetchCollegesInfoListUseCase {
    let repository: UniversityRepository
    
    public init(repository: UniversityRepository) {
        self.repository = repository
    }
    
    public func execute(universityName: String) async throws -> [CollegesInfoModel] {
        let entity = try await repository.getCollegesInfoList(university: universityName)
        
        return convertToModel(entity)
    }
}

extension FetchCollegesInfoListUseCaseImpl {
    func convertToModel(_ entity: [CollegesInfoEntity]) -> [CollegesInfoModel] {
        return entity.map {
            CollegesInfoModel(
                id: $0.id,
                collegesName: $0.collegeName
            )
        }
    }
}
