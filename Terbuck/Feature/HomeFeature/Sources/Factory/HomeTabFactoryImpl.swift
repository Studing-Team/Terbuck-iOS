//
//  HomeTabFactoryImpl.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit
import HomeInterface
import NotificationSettingInterface
import RegisterStudentCardInterface

public final class HomeTabFactoryImpl: HomeTabFactory {
    
    private let alarmSettingFactory: AlarmSettingFactory
    private let registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    
    public init(
        alarmSettingFactory: AlarmSettingFactory,
        registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    ) {
        self.alarmSettingFactory = alarmSettingFactory
        self.registerStudentCardFactory = registerStudentCardFactory
    }
    
    public func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinating {
        
        let homeFactory = HomeFactoryImpl()
        let partnershipFactory = PartnershipFactoryImpl()
        
        return HomeCoordinator(
            navigationController: navigationController,
            homeFactory: homeFactory,
            partnershipFactory: partnershipFactory,
            alarmSettingFactory: alarmSettingFactory,
            registerStudentCardFactory: registerStudentCardFactory
        )
    }
}
