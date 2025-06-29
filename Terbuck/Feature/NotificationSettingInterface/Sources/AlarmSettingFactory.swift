//
//  AlarmSettingFactory.swift
//  NotificationSettingInterface
//
//  Created by ParkJunHyuk on 6/27/25.
//

import UIKit

public protocol AlarmSettingFactory {
    func makeAlarmSettingViewController(coordinator: AlarmSettingCoordinating) -> UIViewController
}
