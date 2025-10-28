//
//  RegisterStudentCardCoordinator.swift
//  RegisterStudentCardFeature
//
//  Created by ParkJunHyuk on 7/10/25.
//

import UIKit

import RegisterStudentCardInterface
import Shared

final class RegisterStudentCardCoordinator: RegisterStudentCardCoordinating, PoppableCoordinator {
        
    var childCoordinators: [any Coordinator] = []
    var rootViewController: UIViewController?
    
    weak var delegate: RegisterStudentCardCoordinatorDelegate?
    
    private let registerStudentCardFactory: RegisterStudentCardFactory
    var navigationController: UINavigationController
    
    private let initialType: AuthStudentType
    private let initialLocation: CGRect?

    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        registerStudentCardFactory: RegisterStudentCardFactory,
        initialType: AuthStudentType,
        initialLocation: CGRect?
    ) {
        self.navigationController = navigationController
        self.registerStudentCardFactory = registerStudentCardFactory
        self.initialType = initialType
        self.initialLocation = initialLocation
    }
    
    deinit {
        AppLogger.log("RegisterStudentCardCoordinator Deinit", .info, .ui)
    }
    
    // MARK: - Method
    
    func start() {
        switch initialType {
        case .auth:
            // 인증된 사용자 화면 보여주기
            showStudentIdCard(location: initialLocation, type: .auth)
        case .onboarding:
            // 온보딩 화면 보여주기
            showStudentIdCard(location: initialLocation, type: .onboarding)
        case .register:
            // 학생증 등록 화면 보여주기
            showRegisterStudentCard()
        }
    }
    
    func showRegisterStudentCard() {
        let registerStudentIDCardVC = registerStudentCardFactory.makeRegisterStudentCardViewController(coordinator: self)
        self.rootViewController = registerStudentIDCardVC
        navigationController.pushViewController(registerStudentIDCardVC, animated: true)
    }
    
    func showStudentIdCard(
        location: CGRect? ,
        type: AuthStudentUIType
    ) {
        let studentIdCardVC = registerStudentCardFactory.makeStudentIdCardViewController(
            type: type,
            location: location,
            coordinator: self
        )
        
        studentIdCardVC.modalPresentationStyle = .overFullScreen
        navigationController.present(studentIdCardVC, animated: false)
    }
    
    func dismissAuthStudentID() {
        navigationController.dismiss(animated: false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.showRegisterStudentCard()
            }
        }
    }

    func didFinishRegistration() {
        delegate?.didFinishRegisterStudentCard(coordinator: self)
    }
}
