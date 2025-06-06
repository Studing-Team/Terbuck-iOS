//
//  SearchStudentInfoUseCase.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public protocol SearchStudentInfoUseCase {
    func execute() async throws -> UserInfoModel
}

public struct SearchStudentInfoUseCaseImpl: SearchStudentInfoUseCase {
    let repository: MemberRepository
    
    public func execute() async throws -> UserInfoModel {
        let entity = try await repository.getStudentInfo()
        
        return UserInfoModel(
            userName: entity.studentName,
            studentId: entity.studentNum,
            university: "",
            isAuthenticated: false
        )
    }
}
