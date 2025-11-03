//
//  DeleteMemberUseCase.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 6/19/25.
//

import Foundation

public protocol DeleteMemberUseCase {
    func execute() async throws -> Void
}