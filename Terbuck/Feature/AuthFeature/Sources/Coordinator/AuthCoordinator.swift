//
//  AuthCoordinator.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import UIKit

import AuthInterface
import UniversityInfoInterface
import Shared

public final class AuthCoordinator: AuthCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let loginFactory: LoginFactory
    private let termsFactory: TermsFactory
    private let universityInfoFactory: UniversityInfoFactory
    
    public weak var delegate: AuthCoordinatorDelegate?
    
    private var signupViewModel: TermsOfServiceViewModel?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        loginFactory: LoginFactory,
        termsFactory: TermsFactory,
        universityInfoFactory: UniversityInfoFactory
    ) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
        self.termsFactory = termsFactory
        self.universityInfoFactory = universityInfoFactory
    }
    
    public func start() {
        startLogin()
    }
    
    public func startLogin() {
        let loginVC = loginFactory.makeLoginViewController(coordinator: self)
        navigationController.pushViewController(loginVC, animated: true)
    }

    public func startTermsOfService() {
        signupViewModel = termsFactory.makeTermsViewModel()
        
        guard let signupViewModel else { return }
        
        let termsOfServiceVC = termsFactory.makeTermsViewController(coordinator: self, viewModel: signupViewModel)
        termsOfServiceVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(termsOfServiceVC, animated: true)
    }
    
    public func finishAuthFlow() {
        delegate?.didFinishAuthFlow()
    }
}

// MARK: - 대학교 설정을 위한 Coordinator

extension AuthCoordinator: UniversityInfoCoordinating {
    public func showUniversity() {
        let universityVC = universityInfoFactory.makeUniversityInfoViewController(
            type: .register,
            coordinator: self,
            onFinish: { [weak self] in
                self?.finishAuthFlow()
            }
        )

        universityVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(universityVC, animated: true)
    }
}
