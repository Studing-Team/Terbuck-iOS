//
//  SearchStudentInfoUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol SearchStudentInfoUseCaseFactory {
    func makeSearchStudentInfoUseCase() -> any SearchStudentInfoUseCase
}