//
//  GetUniversityInfoListUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation

public protocol GetUniversityInfoListUseCaseFactory {
    func makeGetUniversityInfoListUseCase() -> any GetUniversityInfoListUseCase
}