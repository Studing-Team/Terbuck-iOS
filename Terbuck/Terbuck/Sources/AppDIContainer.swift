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
import Domain
import DomainInterface

public final class AppDIContainer {
    lazy var socialLoginFactory: SocialLoginUseCaseFactory = {
      return SocialLoginUseCaseFactoryImpl()
    }()

    lazy var searchStudentFactory: SearchStudentInfoUseCaseFactory = {
      return SearchStudentInfoUseCaseFactoryImpl()
    }()

    lazy var appleServiceFactory: AppleServiceLoginUseCaseFactory = {
      return AppleServiceLoginUseCaseFactoryImpl()
    }()

    lazy var kakaoServiceFactory: KakaoServiceLoginUseCaseFactory = {
      return KakaoServiceLoginUseCaseFactoryImpl()
    }()
    
    
    func makeSplashFactory() -> SplashFactory {
        return SplashFactoryImpl()
    }
    
    func makeAuthFactory () -> AuthFactory {
        return AuthFactoryImpl(
            socialLoginFactory: socialLoginFactory,
            searchStudentFactory: searchStudentFactory,
            appleServiceFactory: appleServiceFactory,
            kakaoServiceFactory: kakaoServiceFactory,
            universityInfoCoordinatorFactory: universityInfoCoordinatorFactory()
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
            universityInfoCoordinatorFactory: universityInfoCoordinatorFactory(),
            registerStudentCardFactory: registerStudentCardFactory()
        )
    }
    
    func makeAlarmSettingFactory() -> AlarmSettingFactory {
        return AlarmSettingFactoryImpl()
    }
    
    func makeUniversityInfoFactory() -> UniversityInfoFactory {
        return UniversityInfoFactoryImpl()
    }
    
    func makeCollegeInfoFactory() -> CollegeInfoFactory {
        return CollegeInfoFactoryImpl()
    }
    
    func registerStudentCardFactory() -> RegisterStudentCardCoordinatorFactory {
        return RegisterStudentCardCoordinatorFactoryImpl(registerStudentCardFactory: RegisterStudentCardFactoryImpl())
    }
    
    func universityInfoCoordinatorFactory() -> UniversityInfoCoordinatorFactory {
        return UniversityInfoCoordinatorFactoryImpl(
            universityInfoFactory: makeUniversityInfoFactory(),
            collegeInfoFactory: makeCollegeInfoFactory()
        )
    }
}
