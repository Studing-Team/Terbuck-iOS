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
import UniversityInfoInterface
import UniversityInfoFeature
import RegisterStudentCardInterface
import RegisterStudentCardFeature

public final class AppDIContainer {
    func makeSplashFactory() -> SplashFactory {
        return SplashFactoryImpl()
    }
    
    func makeAuthFactory() -> AuthFactory {
        return AuthFactoryImpl(
            universityInfoFactory: makeUniversityInfoFactory()
        )
    }
    
    func makeHomeFactory() -> HomeTabFactory {
        return HomeTabFactoryImpl(
            alarmSettingFactory: makeAlarmSettingFactory(),
            registerStudentCardFactory: registerStudentCardFactory()
        )
    }
    
    func makeStoreFactory() -> StoreTabFactory {
        return StoreTabFactoryImpl(
            registerStudentCardFactory: registerStudentCardFactory()
        )
    }
    
    func makeMypageFactory() -> MypageTabFactory {
        return MypageTabFactoryImpl(
            alarmSettingFactory: makeAlarmSettingFactory(),
            universityInfoFactory: makeUniversityInfoFactory(),
            registerStudentCardFactory: registerStudentCardFactory()
        )
    }
    
    func makeAlarmSettingFactory() -> AlarmSettingFactory {
        return AlarmSettingFactoryImpl()
    }
    
    func makeUniversityInfoFactory() -> UniversityInfoFactory {
        return UniversityInfoFactoryImpl()
    }
    
    func registerStudentCardFactory() -> RegisterStudentCardCoordinatorFactory {
        return RegisterStudentCardCoordinatorFactoryImpl(registerStudentCardFactory: RegisterStudentCardFactoryImpl())
    }
}
