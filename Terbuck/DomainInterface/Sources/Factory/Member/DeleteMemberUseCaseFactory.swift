//
//  DeleteMemberUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 6/19/25.
//

import Foundation

public protocol DeleteMemberUseCaseFactory {
    func makeDeleteMemberUseCase() -> any DeleteMemberUseCase
}