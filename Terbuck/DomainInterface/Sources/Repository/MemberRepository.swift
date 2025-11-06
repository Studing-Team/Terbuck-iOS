//
//  MemberRepository.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol MemberRepository {
    func getStudentInfo() async throws -> SearchStudentInfoEntity
    func deleteMember() async throws -> Void
    func putRegisterStudentId(idCardImage: Data, name: String, studentNumber: String) async throws -> Void
    func deleteStudentId() async throws -> Void
    func postSignup(university: String, collegeId: Int) async throws -> Void
    func patchUniversityInfo(university: String, collegeId: Int) async throws -> Void
}
