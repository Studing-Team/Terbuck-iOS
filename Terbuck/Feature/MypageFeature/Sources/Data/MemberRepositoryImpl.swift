//
//  MemberRepositoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import CoreNetwork

protocol MemberRepository {
    func getStudentInfo() async throws -> SearchStudentInfoEntity
    func deleteMember() async throws -> Void
    func putRegisterStudentId(idCardImage: Data, name: String, studentNumber: String) async throws -> Void
    func deleteStudentId() async throws -> Void
}

struct MemberRepositoryImpl: MemberRepository {
    
    // MARK: - Property
    
    private let networkManager = NetworkManager.shared

    func getStudentInfo() async throws -> SearchStudentInfoEntity {
        let dto: SearchStudentInfoResponseDTO = try await networkManager.request(MemberAPIEndpoint.getStudentId)
        return dto.toEntity()
    }
    
    func deleteMember() async throws -> Void {
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.deleteMemeber)
    }
    
    func putRegisterStudentId(idCardImage: Data, name: String, studentNumber: String) async throws -> Void {
        let requestDTO = RegisterStudentIDRequestDTO(image: idCardImage, name: name, studentNumber: studentNumber)
        
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.putRegisterStudentId(requestDTO))
    }
    
    func deleteStudentId() async throws -> Void {
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.deleteStudentId)
    }
}
