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
import NotificationSettingInterface
import NotificationSettingFeature

public final class AppDIContainer {
    func makeSplashFactory() -> SplashFactory {
        return SplashFactoryImpl()
    }
    
    func makeAuthFactory() -> AuthFactory {
        return AuthFactoryImpl()
    }
    
    func makeHomeFactory() -> HomeTabFactory {
        return HomeTabFactoryImpl(alarmSettingFactory: makeAlarmSettingFactory())
    }
    
    func makeStoreFactory() -> StoreTabFactory {
        return StoreTabFactoryImpl()
    }
    
    func makeMypageFactory() -> MypageTabFactory {
        return MypageTabFactoryImpl(alarmSettingFactory: makeAlarmSettingFactory())
    }
    
    func makeAlarmSettingFactory() -> AlarmSettingFactory {
        return AlarmSettingFactoryImpl()
    }
}
