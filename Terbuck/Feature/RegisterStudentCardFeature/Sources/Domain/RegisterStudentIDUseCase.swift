//
//  RegisterStudentIDUseCase.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/4/25.
//

import Foundation

public protocol RegisterStudentIDUseCase {
    func execute(imageData: Data, studentName: String, studentId: String) async throws
}

public struct RegisterStudentIDUseCaseImpl: RegisterStudentIDUseCase {
    let repository: RegisterRepository
    
    public init(repository: RegisterRepository) {
        self.repository = repository
    }
    
    public func execute(imageData: Data, studentName: String, studentId: String) async throws  {
        try await repository.putRegisterStudentId(image: imageData, name: studentName, studentId: studentId)
    }
}
