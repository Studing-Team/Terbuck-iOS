//
//  MypageTabFactoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit
import MypageInterface
import NotificationSettingInterface

public final class MypageTabFactoryImpl: MypageTabFactory {
    
    private let alarmSettingFactory: AlarmSettingFactory
    
    public init(alarmSettingFactory: AlarmSettingFactory) {
        self.alarmSettingFactory = alarmSettingFactory
    }
    
    public func makeMypageCoordinator(navigationController: UINavigationController) -> MypageCoordinating {
        
        let mypageFactory = MypageFactoryImpl()
        
        return MypageCoordinator(
            navigationController: navigationController,
            mypageFactory: mypageFactory,
            alarmSettingFactory: alarmSettingFactory
        )
    }
}
