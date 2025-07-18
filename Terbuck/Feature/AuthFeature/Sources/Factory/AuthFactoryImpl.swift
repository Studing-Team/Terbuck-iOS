//
//  AuthFactoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit
import AuthInterface
import UniversityInfoInterface

public final class AuthFactoryImpl: AuthFactory {
    
    private let universityInfoFactory: UniversityInfoFactory
    
    public init(
        universityInfoFactory: UniversityInfoFactory
    ) {
        self.universityInfoFactory = universityInfoFactory
    }

    public func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinating {
        let loginFactory = LoginFactoryImpl()
        let termsFactory = TermsOfServiceFactoryImpl()

        return AuthCoordinator(
            navigationController: navigationController,
            loginFactory: loginFactory,
            termsFactory: termsFactory,
            universityInfoFactory: universityInfoFactory,
        )
    }
}
