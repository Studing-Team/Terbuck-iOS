//
//  DeleteStudentIdUseCase.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public protocol DeleteStudentIdUseCase {
    func execute() async throws -> Void
}