//
//  SplashRepository.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 9/26/25.
//

import Foundation
import CoreNetwork

public protocol SplashRepository {
    func getStudentInfo() async throws -> SearchStudentInfoEntity
    func getCheckUpdateState(version: String) async throws -> CheckUpdateStateInfoEntity
}

public struct SplashRepositoryImpl: SplashRepository {
    
    private let networkManager = NetworkManager.shared
    
    public init() {}
    
    public func getStudentInfo() async throws -> SearchStudentInfoEntity {
        let dto: SearchStudentInfoResponseDTO = try await networkManager.request(MemberAPIEndpoint.getStudentId)
        return dto.toEntity()
    }
    
    public func getCheckUpdateState(version: String) async throws -> CheckUpdateStateInfoEntity {
        let requestDTO = CheckUpdateStateRequestDTO(version: version)
        
        let dto: CheckUpdateStateResponseDTO = try await networkManager.request(InfomationAPIEndpoint.getCheckUpdateState(requestDTO))
        return dto.toEntity()
    }
}
