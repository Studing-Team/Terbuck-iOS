//
//  AppDIContainer.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/16/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import Foundation

import SplashInterface
import SplashFeature
import AuthInterface
import AuthFeature
import HomeInterface
import HomeFeature
import StoreInterface
import StoreFeature
import MypageInterface
import MypageFeature

public final class AppDIContainer {
    func makeSplashFactory() -> SplashFactory {
        return SplashFactoryImpl()
    }
    
    func makeAuthFactory() -> AuthFactory {
        return AuthFactoryImpl()
    }
    
    func makeHomeFactory() -> HomeTabFactory {
        return HomeTabFactoryImpl()
    }
    
    func makeStoreFactory() -> StoreTabFactory {
        return StoreTabFactoryImpl()
    }
    
    func makeMypageFactory() -> MypageTabFactory {
        return MypageTabFactoryImpl()
    }
}
