//
//  AuthCoordinator.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import UIKit

import AuthInterface
import Shared

public final class AuthCoordinator: AuthCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let loginFactory: LoginFactory
    private let termsFactory: TermsFactory
    private let universityFactory: UniversityFactory
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        loginFactory: LoginFactory,
        termsFactory: TermsFactory,
        universityFactory: UniversityFactory
    ) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
        self.termsFactory = termsFactory
        self.universityFactory = universityFactory
    }
    
    public func start() {
        startLogin()
    }
    
    public func startLogin() {
        let loginVC = loginFactory.makeLoginViewController(coordinator: self)
        navigationController.pushViewController(loginVC, animated: true)
    }

    public func startTermsOfService() {
        let termsOfServiceVC = termsFactory.makeTermsViewController(coordinator: self)
        navigationController.pushViewController(termsOfServiceVC, animated: true)
    }
    
    public func startUniversity() {
        let universityVC = universityFactory.makeUniversityViewController(coordinator: self)
        navigationController.pushViewController(universityVC, animated: true)
    }

    public func finishAuthFlow() {
        // TODO: 회원가입 후
    }
}
