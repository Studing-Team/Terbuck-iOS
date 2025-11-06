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
    
    /// 회언의 학생증을 조회하는 API 를 호출합니다.
    public func getStudentInfo() async throws -> SearchStudentInfoEntity {
        let dto: SearchStudentInfoResponseDTO = try await networkManager.request(MemberAPIEndpoint.getStudentId)
        return dto.toEntity()
    }
    
    /// 회원의 계정을 탈퇴하는 API 를 호출합니다.
    public func deleteMember() async throws -> Void {
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.deleteMember)
    }
    
    /// 회원의 학생증 이미지를 등록하는 API 를 호출합니다.
    public func putRegisterStudentId(idCardImage: Data, name: String, studentNumber: String) async throws -> Void {
        let requestDTO = RegisterStudentIDRequestDTO(image: idCardImage, name: name, studentNumber: studentNumber)
        
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.putRegisterStudentId(requestDTO))
    }
    
    /// 회원의 학생증을 삭제하는 API 를 호출합니다.
    public func deleteStudentId() async throws -> Void {
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.deleteStudentId)
    }
    
    /// 회원가입을 위해 대학교 정보를 등록하는 API 를 호출합니다.
    public func postSignup(university: String, collegeId: Int) async throws -> Void {
        let requestDTO = SignupRequestDTO(university: university, collegeId: collegeId)
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.postSignin(requestDTO))
    }
    
    /// 회원의 대학교 정보를 변경하는 API 를 호출합니다.
    public func patchUniversityInfo(university: String, collegeId: Int) async throws -> Void {
        let requestDTO = ChangeUniversityRequestDTO(university: university, collegeId: collegeId)
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.patchUniversity(requestDTO))
    }
}
