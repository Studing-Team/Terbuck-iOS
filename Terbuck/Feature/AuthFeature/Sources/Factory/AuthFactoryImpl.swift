//
//  AuthFactoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit
import AuthInterface
import DomainInterface
import UniversityInfoInterface

public final class AuthFactoryImpl: AuthFactory {
    
    private let socialLoginFactory: SocialLoginUseCaseFactory
    private let searchStudentFactory: SearchStudentInfoUseCaseFactory
    private let appleServiceFactory: AppleServiceLoginUseCaseFactory
    private let kakaoServiceFactory: KakaoServiceLoginUseCaseFactory
    private let universityInfoCoordinatorFactory: UniversityInfoCoordinatorFactory
    
    // MARK: - Init
    
    public init(
        socialLoginFactory: SocialLoginUseCaseFactory,
        searchStudentFactory: SearchStudentInfoUseCaseFactory,
        appleServiceFactory: AppleServiceLoginUseCaseFactory,
        kakaoServiceFactory: KakaoServiceLoginUseCaseFactory,
        universityInfoCoordinatorFactory: UniversityInfoCoordinatorFactory
    ) {
        self.socialLoginFactory = socialLoginFactory
        self.searchStudentFactory = searchStudentFactory
        self.appleServiceFactory = appleServiceFactory
        self.kakaoServiceFactory = kakaoServiceFactory
        self.universityInfoCoordinatorFactory = universityInfoCoordinatorFactory
    }

    public func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinating {
        let loginFactory = LoginFactoryImpl(
            socialLoginFactory: socialLoginFactory,
            appleServiceFactory: appleServiceFactory,
            kakaoServiceFactory: kakaoServiceFactory,
            searchStudentFactory: searchStudentFactory
        )
        let termsFactory = TermsOfServiceFactoryImpl()

        return AuthCoordinator(
            navigationController: navigationController,
            loginFactory: loginFactory,
            termsFactory: termsFactory,
            universityInfoCoordinatorFactory: universityInfoCoordinatorFactory,
        )
    }
}
