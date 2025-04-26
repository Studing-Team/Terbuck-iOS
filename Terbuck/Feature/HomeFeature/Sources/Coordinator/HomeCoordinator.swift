//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import UIKit

import HomeInterface
import DesignSystem
import Shared

public class HomeCoordinator: HomeCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let homeFactory: HomeFactory
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        homeFactory: HomeFactory
    ) {
        self.navigationController = navigationController
        self.homeFactory = homeFactory
    }
    
    // MARK: - Method
    
    public func start() {
        startHome()
    }
    
    public func startHome() {
        let homeVC = homeFactory.makeHomeViewController(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
    }
}

extension HomeCoordinator: StudentIDCardFlowDelegate {
    public func showOnboardiing(location: CGRect) {
        let studentIdCardVC = StudentIDCardViewController(
            authType: .onboarding,
            location: location,
            coordinator: self
        )
        studentIdCardVC.modalPresentationStyle = .overFullScreen
        navigationController.present(studentIdCardVC, animated: false)
    }
    
    public func showAuthStudentID() {
        let studentIdCardVC = StudentIDCardViewController(
            authType: .auth,
            coordinator: self
        )
        
        studentIdCardVC.modalPresentationStyle = .overFullScreen
        navigationController.present(studentIdCardVC, animated: false)
    }
    
    public func dismissAuthStudentID() {
        navigationController.dismiss(animated: false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.registerStudentID()
            }
        }
    }
    
    public func registerStudentID() {
        let registerStudentIDCardVC = RegisterStudentCardViewController()
        registerStudentIDCardVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(registerStudentIDCardVC, animated: true)
    }
}
