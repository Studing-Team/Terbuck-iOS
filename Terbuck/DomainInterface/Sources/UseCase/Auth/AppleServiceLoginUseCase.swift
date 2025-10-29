//
//  AppleServiceLoginUseCase.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol AppleServiceLoginUseCase {
    func execute() async throws -> (code: String, name: String)
}