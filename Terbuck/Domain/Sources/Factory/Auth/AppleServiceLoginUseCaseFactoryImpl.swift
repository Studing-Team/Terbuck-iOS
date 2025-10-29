//
//  AppleServiceLoginUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface
import Data

public struct AppleServiceLoginUseCaseFactoryImpl: AppleServiceLoginUseCaseFactory {
    public init() {}
    
    public func makeAppleServiceLoginUseCase() -> any AppleServiceLoginUseCase {
        let repository = AuthRepositoryImpl()
        return AppleServiceLoginUseCaseImpl(repository: repository)
    }
}