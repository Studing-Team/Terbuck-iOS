//
//  AuthFactoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit
import AuthInterface

public final class AuthFactoryImpl: AuthFactory {
    
    public init() {}

    public func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinating {
        let loginFactory = LoginFactoryImpl()
        let termsFactory = TermsOfServiceFactoryImpl()
        let universityFactory = UniversityFactoryImpl()

        return AuthCoordinator(
            navigationController: navigationController,
            loginFactory: loginFactory,
            termsFactory: termsFactory,
            universityFactory: universityFactory
        )
    }
}
