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

public final class AuthCoordinator: BaseCoordinator, AuthCoordinating {
    
    public var rootViewController: UIViewController?
    
    private let loginFactory: LoginFactory
    private let termsFactory: TermsFactory
    private let universityInfoCoordinatorFactory: UniversityInfoCoordinatorFactory
    
    public weak var delegate: AuthCoordinatorDelegate?
    
    private var signupViewModel: TermsOfServiceViewModel?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        loginFactory: LoginFactory,
        termsFactory: TermsFactory,
        universityInfoCoordinatorFactory: UniversityInfoCoordinatorFactory
    ) {
        self.loginFactory = loginFactory
        self.termsFactory = termsFactory
        self.universityInfoCoordinatorFactory = universityInfoCoordinatorFactory
        super.init(navigationController: navigationController)
    }
    
    public override func start() {
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
        navigationController.pushViewController(termsOfServiceVC, animated: true)
    }
    
    public func showUniversity() {
        let universityCoordinator = universityInfoCoordinatorFactory.makeUniversityInfoCoordinator(
            navigationController: self.navigationController,
            initialType: .register
        )
        
        universityCoordinator.delegate = self
        
        childCoordinators.append(universityCoordinator)
        universityCoordinator.start()
    }
    
    public func finishAuthFlow() {
        delegate?.didFinishAuthFlow()
    }
}

// MARK: - 대학교 설정을 위한 Coordinator

extension AuthCoordinator: UniversityInfoCoordinatorDelegate {
    public func didFinishUniversityInfo(coordinator: Coordinator, initialType: UniversityType) {
        
        if initialType == .edit {
            // 대학교 변경 관련 로직, 이전 화면으로 이동
            childCoordinators = childCoordinators.filter { $0 !== coordinator }
        } else {
            // 회원가입 시 Main 화면으로 이동
            finishAuthFlow()
        }
    }
}
