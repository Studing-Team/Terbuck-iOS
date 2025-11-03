//
//  SignupUseCase.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation

public protocol SignupUseCase {
    func execute(university: String, collegeId: Int) async throws -> Void
}