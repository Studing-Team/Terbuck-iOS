//
//  UpdateUniversityUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation

public protocol UpdateUniversityUseCaseFactory {
    func makeUpdateUniversityUseCase() -> any UpdateUniversityUseCase
}