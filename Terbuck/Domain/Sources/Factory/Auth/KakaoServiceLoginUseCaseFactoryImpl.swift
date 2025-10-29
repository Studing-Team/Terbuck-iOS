//
//  KakaoServiceLoginUseCaseFactoryImpl.swift
//  Domain
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import DomainInterface
import Data

public struct KakaoServiceLoginUseCaseFactoryImpl: KakaoServiceLoginUseCaseFactory {
    public init() {}
    
    public func makeKakaoServiceLoginUseCase() -> any KakaoServiceLoginUseCase {
        let repository = AuthRepositoryImpl()
        return KakaoServiceLoginUseCaseImpl(repository: repository)
    }
}
