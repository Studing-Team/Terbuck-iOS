//
//  RegisterStudentIdUseCase.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public protocol RegisterStudentIdUseCase {
    func execute(idCardImage: Data, name: String, studentNumber: String) async throws -> Void
}