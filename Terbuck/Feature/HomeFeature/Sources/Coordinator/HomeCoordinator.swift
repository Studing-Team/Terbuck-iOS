//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import UIKit

import HomeInterface
import NotificationSettingInterface
import RegisterStudentCardInterface
import DesignSystem
import Shared

public class HomeCoordinator: HomeCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let homeFactory: HomeFactory
    private let partnershipFactory: PartnershipFactory
    private let alarmSettingFactory: AlarmSettingFactory
    private let registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        homeFactory: HomeFactory,
        partnershipFactory: PartnershipFactory,
        alarmSettingFactory: AlarmSettingFactory,
        registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    ) {
        self.navigationController = navigationController
        self.homeFactory = homeFactory
        self.partnershipFactory = partnershipFactory
        self.alarmSettingFactory = alarmSettingFactory
        self.registerStudentCardFactory = registerStudentCardFactory
    }
    
    // MARK: - Method
    
    public func start() {
        startHome()
    }
    
    public func startHome() {
        let homeVC = homeFactory.makeHomeViewController(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
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
    
    public func startRegisterStudentCard(for type: AuthStudentType, location: CGRect?) {
        let registerCoordinator = registerStudentCardFactory.makeRegisterStudentCardCoordinator(
            navigationController: self.navigationController,
            initialType: type,
            initialLocation: location
        )

        registerCoordinator.delegate = self
        
        childCoordinators.append(registerCoordinator)
        
        registerCoordinator.start()
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

// MARK: - 학생증 재등록을 위한 Coordinator

extension HomeCoordinator: RegisterStudentCardCoordinatorDelegate {
    public func didFinishRegisterStudentCard(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
