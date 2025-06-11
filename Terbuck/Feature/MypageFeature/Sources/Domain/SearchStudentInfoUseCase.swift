//
//  SearchStudentInfoUseCase.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import Shared

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
            university: UserDefaultsManager.shared.string(for: .university) ?? "정보 없음",
            isAuthenticated: true,
            imageUrl: entity.imageUrl
        )
    }
}
