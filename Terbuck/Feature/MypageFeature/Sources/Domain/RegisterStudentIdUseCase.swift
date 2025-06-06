//
//  RegisterStudentIdUseCase.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public protocol RegisterStudentIdUseCase {
    func execute(idCardImage: Data, name: String, studentNumber: String) async throws -> Void
}

public struct RegisterStudentIdUseCaseImpl: RegisterStudentIdUseCase {
    let repository: MemberRepository
    
    public func execute(
        idCardImage: Data,
        name: String,
        studentNumber: String
    ) async throws -> Void {
        try await repository.putRegisterStudentId(
            idCardImage: idCardImage,
            name: name,
            studentNumber: studentNumber
        )
    }
}
