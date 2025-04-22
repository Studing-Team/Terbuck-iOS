//
//  AppDIContainer.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/16/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import Foundation

import AuthInterface
import AuthFeature
import MypageInterface
import MypageFeature

public final class AppDIContainer {
    func makeAuthFactory() -> AuthFactory {
        return AuthFactoryImpl()
    }
    
    func makeMypageFactory() -> MypageTabFactory {
        return MypageTabFactoryImpl()
    }
}
