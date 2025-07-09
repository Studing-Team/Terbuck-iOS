//
//  AlarmSettingFactoryImpl.swift
//  NotificationSettingFeature
//
//  Created by ParkJunHyuk on 6/27/25.
//

import UIKit

import NotificationSettingInterface

public final class AlarmSettingFactoryImpl: AlarmSettingFactory {

    public init() {}

    public func makeAlarmSettingViewController(coordinator: AlarmSettingCoordinating) -> UIViewController {
        
        let alarmSettingViewModel = AlarmSettingViewModel()
        
        return AlarmSettingViewControllor(
            alarmSettingViewModel: alarmSettingViewModel,
            coordinator: coordinator
        )
    }
}
