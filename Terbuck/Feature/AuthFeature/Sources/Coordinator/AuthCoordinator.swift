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
    
    public weak var delegate: AuthCoordinatorDelegate?
    
    private var signupViewModel: TermsOfServiceViewModel?
    
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
        signupViewModel = termsFactory.makeTermsViewModel()
        
        guard let signupViewModel else { return }
        
        let termsOfServiceVC = termsFactory.makeTermsViewController(coordinator: self, viewModel: signupViewModel)
        termsOfServiceVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(termsOfServiceVC, animated: true)
    }
    
    public func startUniversity() {
        let viewModel = UniversityViewModel(
            signupUseCase: SignupUseCaseImpl(repository: AuthRepositoryImpl())
        )
        
        let universityVC = universityFactory.makeUniversityViewController(
            coordinator: self,
            viewModel: viewModel
        )
        universityVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(universityVC, animated: true)
    }

    public func finishAuthFlow() {
        delegate?.didFinishAuthFlow()
    }
}
