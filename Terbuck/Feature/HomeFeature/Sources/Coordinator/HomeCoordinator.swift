//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import UIKit

import HomeInterface
import NotificationSettingInterface
import RegisterStudentCardFeature
import DesignSystem
import Shared

public class HomeCoordinator: HomeCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let homeFactory: HomeFactory
    private let partnershipFactory: PartnershipFactory
    private let alarmSettingFactory: AlarmSettingFactory
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        homeFactory: HomeFactory,
        partnershipFactory: PartnershipFactory,
        alarmSettingFactory: AlarmSettingFactory
    ) {
        self.navigationController = navigationController
        self.homeFactory = homeFactory
        self.partnershipFactory = partnershipFactory
        self.alarmSettingFactory = alarmSettingFactory
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
            coordinator: self,
            viewModel: StudentIdCardViewModel()
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
            coordinator: self,
            viewModel: StudentIdCardViewModel()
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
}

// MARK: - 알림 Setting Feature

extension HomeCoordinator: AlarmSettingCoordinating {
    public func showAlarmSetting() {
        let alarmSettingVC = alarmSettingFactory.makeAlarmSettingViewController(coordinator: self)
        
        alarmSettingVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(alarmSettingVC, animated: true)
    }
}

// MARK: - 학생증 등록 Feature

public extension HomeCoordinator {
    func registerStudentID() {
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
