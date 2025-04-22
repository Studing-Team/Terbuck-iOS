//
//  AlarmSettingFactoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit
import MypageInterface

public protocol AlarmSettingFactory {
    func makeAlarmSettingViewController(coordinator: MypageCoordinator) -> UIViewController
}

public final class AlarmSettingFactoryImpl: AlarmSettingFactory {

    public init() {}

    public func makeAlarmSettingViewController(coordinator: MypageCoordinator) -> UIViewController {
        
        let alarmSettingViewModel = AlarmSettingViewModel()
        
        return AlarmSettingViewControllor(
            alarmSettingViewModel: alarmSettingViewModel,
            coordinator: coordinator
        )
    }
}
