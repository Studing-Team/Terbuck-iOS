//
//  MemberRepository.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol MemberRepository {
    func getStudentInfo() async throws -> SearchStudentInfoEntity
}