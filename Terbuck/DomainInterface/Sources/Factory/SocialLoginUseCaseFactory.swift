//
//  SocialLoginUseCaseFactory.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol SocialLoginUseCaseFactory {
    func makeSocialLoginUseCase() -> any SocialLoginUseCase
}