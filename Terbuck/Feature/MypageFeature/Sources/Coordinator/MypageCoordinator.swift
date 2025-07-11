//
//  MypageCoordinator.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit

import MypageInterface
import NotificationSettingInterface
import RegisterStudentCardFeature
import UniversityInfoFeature
import Shared

public class MypageCoordinator: MypageCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let mypageFactory: MypageFactory
    private let alarmSettingFactory: AlarmSettingFactory
    
    public weak var delegate: notAuthCoordinatorDelegate?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        mypageFactory: MypageFactory,
        alarmSettingFactory: AlarmSettingFactory
    ) {
        self.navigationController = navigationController
        self.mypageFactory = mypageFactory
        self.alarmSettingFactory = alarmSettingFactory
    }
    
    // MARK: - Method
    
    public func start() {
        startMypage()
    }
    
    public func startMypage() {
        let mypageVC = mypageFactory.makeMypageViewController(coordinator: self)
        navigationController.pushViewController(mypageVC, animated: true)
    }
    
    public func registerStudentID() {
        let viewModel = RegisterStudentCardViewModel(
            registerStudentIDUseCase: RegisterStudentIDUseCaseImpl(repository: RegisterRepositoryImpl())
        )
        
        let registerStudentIDCardVC = RegisterStudentCardViewController(viewModel: viewModel)
        registerStudentIDCardVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(registerStudentIDCardVC, animated: true)
    }
    
    public func startEditUniversity() {
        let viewModel = UniversityViewModel(editUniversityUseCase: EditUniversityUseCaseImpl(repository: UniversityRepositoryImpl()))
        
        let universityVC = UniversityViewController(
            type: .edit,
            viewModel: viewModel
        )
        
        universityVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(universityVC, animated: true)
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
