//
//  MemberRepositoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import CoreNetwork

protocol MemberRepository {
    func patchUniversityInfo(university: String) async throws -> Void
    func getStudentInfo() async throws -> SearchStudentInfoEntity
    func putRegisterStudentId(idCardImage: Data, name: String, studentNumber: String) async throws -> Void
    func deleteStudentId() async throws -> Void
}

struct MemberRepositoryImpl: MemberRepository {
    
    // MARK: - Property
    
    private let networkManager = NetworkManager.shared
    
    func patchUniversityInfo(university: String) async throws -> Void {
        let requestDTO = ChangeUniversityRequestDTO(university: university)
        
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.patchUniversity(requestDTO))
    }
    
    func getStudentInfo() async throws -> SearchStudentInfoEntity {
        let dto: SearchStudentInfoResponseDTO = try await networkManager.request(MemberAPIEndpoint.getStudentId)
        return dto.toEntity()
    }
    
    func putRegisterStudentId(idCardImage: Data, name: String, studentNumber: String) async throws -> Void {
        let requestDTO = RegisterStudentIDRequestDTO(idCardImage: idCardImage, name: name, studentNumber: studentNumber)
        
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.putRegisterStudentId(requestDTO))
    }
    
    func deleteStudentId() async throws -> Void {
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.deleteStudentId)
    }
}
