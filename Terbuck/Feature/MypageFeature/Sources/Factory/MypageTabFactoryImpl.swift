//
//  MypageTabFactoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit
import MypageInterface
import NotificationSettingInterface
import UniversityInfoInterface
import RegisterStudentCardInterface

public final class MypageTabFactoryImpl: MypageTabFactory {
    
    private let alarmSettingFactory: AlarmSettingFactory
    private let universityInfoFactory: UniversityInfoFactory
    private let registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    
    public init(
        alarmSettingFactory: AlarmSettingFactory,
        universityInfoFactory: UniversityInfoFactory,
        registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    ) {
        self.alarmSettingFactory = alarmSettingFactory
        self.universityInfoFactory = universityInfoFactory
        self.registerStudentCardFactory = registerStudentCardFactory
    }
    
    public func makeMypageCoordinator(navigationController: UINavigationController) -> MypageCoordinating {
        
        let mypageFactory = MypageFactoryImpl()
        
        return MypageCoordinator(
            navigationController: navigationController,
            mypageFactory: mypageFactory,
            alarmSettingFactory: alarmSettingFactory,
            universityInfoFactory: universityInfoFactory,
            registerStudentCardFactory: registerStudentCardFactory
        )
    }
}
