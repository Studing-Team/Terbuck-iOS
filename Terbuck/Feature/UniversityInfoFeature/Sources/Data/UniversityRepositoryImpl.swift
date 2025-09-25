//
//  UniversityRepositoryImpl.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/11/25.
//

import Foundation
import CoreNetwork

public protocol UniversityRepository {
    func postSignupMember(university: String) async throws -> Void
    func patchUniversityInfo(university: String) async throws -> Void
    func getUniversityInfoList() async throws -> [UniversityInfoEntity]
    func getCollegesInfoList(university: String) async throws -> [CollegesInfoEntity]
}

public struct UniversityRepositoryImpl: UniversityRepository {
    
    private let networkManager = NetworkManager.shared
    
    public init() {}
    
    public func postSignupMember(university: String) async throws {
        let requestDTO = SigninRequestDTO(university: university)
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.postSignin(requestDTO))
    }
    
    public func patchUniversityInfo(university: String) async throws -> Void {
        let requestDTO = ChangeUniversityRequestDTO(university: university)
        
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.patchUniversity(requestDTO))
    }
    
    public func getUniversityInfoList() async throws -> [UniversityInfoEntity] {
        let dto: [UniversityInfoListResponseDTO] = try await networkManager.request(UniversityAPIEndpoint.getUniversityInfoList)
        
        return dto.map { $0.toEntity() }
    }
    
    public func getCollegesInfoList(university: String) async throws -> [CollegesInfoEntity] {
        let requestDTO = MyUniversityRequestDTO(universityName: university)
        
        let dto: [CollegesInfoResponseDTO] = try await networkManager.request(UniversityAPIEndpoint.getCollegesInfoList(requestDTO))
        
        return dto.map { $0.toEntity() }
    }
}
