//
//  HomeTabFactoryImpl.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit
import HomeInterface
import NotificationSettingInterface

public final class HomeTabFactoryImpl: HomeTabFactory {
    
    private let alarmSettingFactory: AlarmSettingFactory
    
    public init(alarmSettingFactory: AlarmSettingFactory) {
        self.alarmSettingFactory = alarmSettingFactory
    }
    
    public func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinating {
        
        let homeFactory = HomeFactoryImpl()
        let partnershipFactory = PartnershipFactoryImpl()
        
        return HomeCoordinator(
            navigationController: navigationController,
            homeFactory: homeFactory,
            partnershipFactory: partnershipFactory,
            alarmSettingFactory: alarmSettingFactory
        )
    }
}
