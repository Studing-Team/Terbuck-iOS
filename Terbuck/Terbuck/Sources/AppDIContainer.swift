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
import Data

public final class AppDIContainer {
    
    // MARK: - Repository
    
    lazy var memberRepository: any MemberRepository = {
        return MemberRepositoryImpl()
    }()
    
    lazy var universityRepository: any UniversityRepository = {
        return UniversityRepositoryImpl()
    }()
    
    // MARK: - UseCase Factories
    
    lazy var socialLoginFactory: SocialLoginUseCaseFactory = {
      return SocialLoginUseCaseFactoryImpl()
    }()

    lazy var searchStudentFactory: SearchStudentInfoUseCaseFactory = {
      return SearchStudentInfoUseCaseFactoryImpl(memberRepository: memberRepository)
    }()

    lazy var appleServiceFactory: AppleServiceLoginUseCaseFactory = {
      return AppleServiceLoginUseCaseFactoryImpl()
    }()

    lazy var kakaoServiceFactory: KakaoServiceLoginUseCaseFactory = {
      return KakaoServiceLoginUseCaseFactoryImpl()
    }()
    
    lazy var deleteMemberUseCaseFactory: DeleteMemberUseCaseFactory = {
        return DeleteMemberUseCaseFactoryImpl(memberRepository: memberRepository)
    }()
    
    lazy var registerStudentIdUseCaseFactory: RegisterStudentIdUseCaseFactory = {
        return RegisterStudentIdUseCaseFactoryImpl(memberRepository: memberRepository)
    }()
    
    lazy var deleteStudentIdUseCaseFactory: DeleteStudentIdUseCaseFactory = {
        return DeleteStudentIdUseCaseFactoryImpl(memberRepository: memberRepository)
    }()
    
    // MARK: - University UseCase Factories
    
    lazy var signupUseCaseFactory: SignupUseCaseFactory = {
        return SignupUseCaseFactoryImpl(memberRepository: memberRepository)
    }()
    
    lazy var updateUniversityUseCaseFactory: UpdateUniversityUseCaseFactory = {
        return UpdateUniversityUseCaseFactoryImpl(memberRepository: memberRepository)
    }()
    
    lazy var getUniversityInfoListUseCaseFactory: GetUniversityInfoListUseCaseFactory = {
        return GetUniversityInfoListUseCaseFactoryImpl(universityRepository: universityRepository)
    }()
    
    lazy var getCollegesInfoListUseCaseFactory: GetCollegesInfoListUseCaseFactory = {
        return GetCollegesInfoListUseCaseFactoryImpl(universityRepository: universityRepository)
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
            registerStudentCardFactory: registerStudentCardFactory(),
            searchStudentInfoUseCaseFactory: searchStudentFactory,
            deleteMemberUseCaseFactory: deleteMemberUseCaseFactory,
        )
    }
    
    func makeAlarmSettingFactory() -> AlarmSettingFactory {
        return AlarmSettingFactoryImpl()
    }
    
    func makeUniversityInfoFactory() -> UniversityInfoFactory {
        return UniversityInfoFactoryImpl(
            getUniversityInfoListUseCaseFactory: getUniversityInfoListUseCaseFactory
        )
    }
    
    func makeCollegeInfoFactory() -> CollegeInfoFactory {
        return CollegeInfoFactoryImpl(
            getCollegesInfoListUseCaseFactory: getCollegesInfoListUseCaseFactory,
            signupUseCaseFactory: signupUseCaseFactory,
            updateUniversityUseCaseFactory: updateUniversityUseCaseFactory
        )
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
