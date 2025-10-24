//
//  LoginFactoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit
import DomainInterface

public protocol LoginFactory {
    func makeLoginViewController(coordinator: AuthCoordinator) -> UIViewController
}

public final class LoginFactoryImpl: LoginFactory {
    private let socialLoginFactory: SocialLoginUseCaseFactory
    private let appleServiceFactory: AppleServiceLoginUseCaseFactory
    private let kakaoServiceFactory: KakaoServiceLoginUseCaseFactory
    private let searchStudentFactory: SearchStudentInfoUseCaseFactory
    
    public init(
        socialLoginFactory: SocialLoginUseCaseFactory,
        appleServiceFactory: AppleServiceLoginUseCaseFactory,
        kakaoServiceFactory: KakaoServiceLoginUseCaseFactory,
        searchStudentFactory: SearchStudentInfoUseCaseFactory
    ) {
        self.socialLoginFactory = socialLoginFactory
        self.appleServiceFactory = appleServiceFactory
        self.kakaoServiceFactory = kakaoServiceFactory
        self.searchStudentFactory = searchStudentFactory
    }

    public func makeLoginViewController(coordinator: AuthCoordinator) -> UIViewController {
        let viewModel = LoginViewModel(
            loginUseCase: socialLoginFactory.makeSocialLoginUseCase(),
            appleServiceLoginUseCase: appleServiceFactory.makeAppleServiceLoginUseCase(),
            kakaoServiceLoginUseCase: kakaoServiceFactory.makeKakaoServiceLoginUseCase(),
            searchStudentInfoUseCase: searchStudentFactory.makeSearchStudentInfoUseCase()
        )
        
        return LoginViewController(viewModel: viewModel, coordinator: coordinator)
    }
}
