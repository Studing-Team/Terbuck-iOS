//
//  MypageCoordinator.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit

import MypageInterface
import NotificationSettingInterface
import RegisterStudentCardInterface
import UniversityInfoInterface
import Shared

public class MypageCoordinator: MypageCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let mypageFactory: MypageFactory
    private let alarmSettingFactory: AlarmSettingFactory
    private let universityInfoFactory: UniversityInfoFactory
    private let registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    
    public weak var delegate: notAuthCoordinatorDelegate?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        mypageFactory: MypageFactory,
        alarmSettingFactory: AlarmSettingFactory,
        universityInfoFactory: UniversityInfoFactory,
        registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    ) {
        self.navigationController = navigationController
        self.mypageFactory = mypageFactory
        self.alarmSettingFactory = alarmSettingFactory
        self.universityInfoFactory = universityInfoFactory
        self.registerStudentCardFactory = registerStudentCardFactory
    }
    
    // MARK: - Method
    
    public func start() {
        startMypage()
    }
    
    public func startMypage() {
        let mypageVC = mypageFactory.makeMypageViewController(coordinator: self)
        navigationController.pushViewController(mypageVC, animated: true)
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
    
    public func moveLoginFlow() {
        delegate?.moveLoginFlow()
    }
}

// MARK: - 알림 Setting Feature

extension MypageCoordinator: AlarmSettingCoordinating {
    public func showAlarmSetting() {
        let alarmSettingVC = alarmSettingFactory.makeAlarmSettingViewController(coordinator: self)
        
        alarmSettingVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(alarmSettingVC, animated: true)
    }
}

// MARK: - 대학교 변경을 위한 Coordinator

extension MypageCoordinator: UniversityInfoCoordinating {
    public func showUniversity() {
        let universityVC = universityInfoFactory.makeUniversityInfoViewController(
            type: .edit,
            coordinator: self
        )

        universityVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(universityVC, animated: true)
    }
}

// MARK: - 학생증 재등록을 위한 Coordinator

extension MypageCoordinator: RegisterStudentCardCoordinatorDelegate {
    public func didFinishRegisterStudentCard(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
