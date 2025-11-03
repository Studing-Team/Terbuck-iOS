//
//  SignupUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation

public protocol SignupUseCaseFactory {
    func makeSignupUseCase() -> any SignupUseCase
}