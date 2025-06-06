//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import UIKit

import HomeInterface
import RegisterStudentCardFeature
import DesignSystem
import Shared

public class HomeCoordinator: HomeCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let homeFactory: HomeFactory
    private let partnershipFactory: PartnershipFactory
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        homeFactory: HomeFactory,
        partnershipFactory: PartnershipFactory
    ) {
        self.navigationController = navigationController
        self.homeFactory = homeFactory
        self.partnershipFactory = partnershipFactory
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
    
    /// 파트너십 혜택 VC
    public func showPartnership(partnershipId: Int) {
        let partnershipVC = partnershipFactory.makePartnershipViewController(
            coordinator: self,
            partnershipId: partnershipId
        )
        
        partnershipVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(partnershipVC, animated: true)
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
        let viewModel = RegisterStudentCardViewModel(
            registerStudentIDUseCase: RegisterStudentIDUseCaseImpl(repository: RegisterRepositoryImpl())
        )
        
        let registerStudentIDCardVC = RegisterStudentCardViewController(viewModel: viewModel)
        registerStudentIDCardVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(registerStudentIDCardVC, animated: true)
    }
}

extension HomeCoordinator: ImagePreviewCoordinating {
    public func showPreviewImage(vm: PreviewImageDisplayable) {
        let previewImageVC = PreviewImageViewController(
            viewModel: vm,
            coordinator: self
        )
        previewImageVC.modalPresentationStyle = .overFullScreen
        navigationController.present(previewImageVC, animated: false)
    }
}
