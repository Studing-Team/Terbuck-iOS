//
//  AppleServiceLoginUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol AppleServiceLoginUseCaseFactory {
    func makeAppleServiceLoginUseCase() -> any AppleServiceLoginUseCase
}