//
//  MypageCoordinator.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit

import MypageInterface
import Shared

public class MypageCoordinator: MypageCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let mypageFactory: MypageFactory
    private let alarmFactory: AlarmSettingFactory
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        mypageFactory: MypageFactory,
        alarmFactory: AlarmSettingFactory
    ) {
        self.navigationController = navigationController
        self.mypageFactory = mypageFactory
        self.alarmFactory = alarmFactory
    }
    
    public func start() {
        startMypage()
    }
    
    public func startMypage() {
        let mypageVC = mypageFactory.makeMypageViewController(coordinator: self)
        navigationController.pushViewController(mypageVC, animated: true)
    }
    
    public func startAlarmSetting() {
        let alarmSettingVC = alarmFactory.makeAlarmSettingViewController(coordinator: self)
        navigationController.pushViewController(alarmSettingVC, animated: true)
    }
}
