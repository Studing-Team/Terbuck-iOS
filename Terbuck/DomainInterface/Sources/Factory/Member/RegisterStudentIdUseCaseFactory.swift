//
//  RegisterStudentIdUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public protocol RegisterStudentIdUseCaseFactory {
    func makeRegisterStudentIdUseCase() -> any RegisterStudentIdUseCase
}