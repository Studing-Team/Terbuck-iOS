//
//  MypageCoordinator.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit

import MypageInterface
import RegisterStudentCardFeature
import Shared

public class MypageCoordinator: MypageCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let mypageFactory: MypageFactory
    private let alarmFactory: AlarmSettingFactory
    private let changeUniversityFactory: ChangeUniversityFactory
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        mypageFactory: MypageFactory,
        alarmFactory: AlarmSettingFactory,
        changeUniversityFactory: ChangeUniversityFactory
    ) {
        self.navigationController = navigationController
        self.mypageFactory = mypageFactory
        self.alarmFactory = alarmFactory
        self.changeUniversityFactory = changeUniversityFactory
    }
    
    // MARK: - Method
    
    public func start() {
        startMypage()
    }
    
    public func startMypage() {
        let mypageVC = mypageFactory.makeMypageViewController(coordinator: self)
        navigationController.pushViewController(mypageVC, animated: true)
    }
    
    public func startAlarmSetting() {
        let alarmSettingVC = alarmFactory.makeAlarmSettingViewController(coordinator: self)
        alarmSettingVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(alarmSettingVC, animated: true)
    }
    
    public func startChangeUniversity() {
        let changeUniversityVC = changeUniversityFactory.makeChangeUniversityViewController(coordinator: self)
        changeUniversityVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(changeUniversityVC, animated: true)
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
