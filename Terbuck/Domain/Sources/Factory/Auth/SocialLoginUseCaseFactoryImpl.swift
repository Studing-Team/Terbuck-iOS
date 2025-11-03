//
//  SocialLoginUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface
import Data

public struct SocialLoginUseCaseFactoryImpl: SocialLoginUseCaseFactory {
    public init() {}
    
    public func makeSocialLoginUseCase() -> any SocialLoginUseCase {
        let authRepository = AuthRepositoryImpl()
        let notificationRepository = NotificationRepositoryImpl()
        return SocialLoginUseCaseImpl(authRepository: authRepository, notificationRepository: notificationRepository)
    }
}
