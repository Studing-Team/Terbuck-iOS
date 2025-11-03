//
//  DeleteStudentIdUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public protocol DeleteStudentIdUseCaseFactory {
    func makeDeleteStudentIdUseCase() -> any DeleteStudentIdUseCase
}