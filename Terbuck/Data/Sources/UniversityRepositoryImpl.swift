//
//  UniversityRepositoryImpl.swift
//  Data
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import CoreNetwork
import DomainInterface

public struct UniversityRepositoryImpl: UniversityRepository {
    
    private let networkManager = NetworkManager.shared
    
    public init() {}
    
    /// 대학교 목록을 조회하는 API 를 호출합니다.
    public func getUniversityInfoList() async throws -> [UniversityInfoEntity] {
        let dto: [UniversityInfoListResponseDTO] = try await networkManager.request(UniversityAPIEndpoint.getUniversityInfoList)
        
        return dto.map { $0.toEntity() }
    }
    
    /// 단과대학 목록을 조회하는 API 를 호출합니다.
    public func getCollegesInfoList(university: String) async throws -> [CollegesInfoEntity] {
        let requestDTO = MyUniversityRequestDTO(universityName: university)
        
        let dto: [CollegesInfoResponseDTO] = try await networkManager.request(UniversityAPIEndpoint.getCollegesInfoList(requestDTO))
        
        return dto.map { $0.toEntity() }
    }
}

// MARK: - DTO Extensions

extension UniversityInfoListResponseDTO {
    func toEntity() -> UniversityInfoEntity {
        let convertUniversityName = self.universities.map {
            $0.name
        }
        
        return UniversityInfoEntity(
            id: region.id,
            regionName: region.name,
            universityNames: convertUniversityName
        )
    }
}

extension CollegesInfoResponseDTO {
    func toEntity() -> CollegesInfoEntity {
        return CollegesInfoEntity(id: id, collegeName: name)
    }
}