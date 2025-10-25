//
//  MemberRepositoryImpl.swift
//  Data
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import CoreNetwork
import DomainInterface

public struct MemberRepositoryImpl: MemberRepository {
    
    private let networkManager = NetworkManager.shared
    
    public init() {}
    
    public func getStudentInfo() async throws -> SearchStudentInfoEntity {
        let dto: SearchStudentInfoResponseDTO = try await networkManager.request(MemberAPIEndpoint.getStudentId)
        return dto.toEntity()
    }
}