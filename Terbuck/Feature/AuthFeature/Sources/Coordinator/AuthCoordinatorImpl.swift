//
//  LoginCoordiantor.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import UIKit

import AuthInterface
import Shared

public final class AuthCoordinatorImpl: AuthCoordinator {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start() {
        startLogin()
    }
    
    public func startLogin() {
        // TODO: 로그인 화면
        let loginVC = LoginViewController()
        navigationController.pushViewController(loginVC, animated: true)
    }

    public func startTermsOfService() {
        // TODO: 약간동의 화면
        let termsOfServiceVC = TermsOfServiceViewController()
        navigationController.pushViewController(termsOfServiceVC, animated: true)
    }
    
    public func startUniversity() {
        // TODO: 대학교 입력 화면
        let universityVC = UniversityInfoViewController()
        navigationController.pushViewController(universityVC, animated: true)
    }

    public func finishAuthFlow() {
        // TODO: 회원가입 후
    }
}
