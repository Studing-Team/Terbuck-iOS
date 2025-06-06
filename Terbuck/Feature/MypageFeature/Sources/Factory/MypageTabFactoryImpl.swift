//
//  MypageTabFactoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit
import MypageInterface

public final class MypageTabFactoryImpl: MypageTabFactory {
    
    public init() {}
    
    public func makeMypageCoordinator(navigationController: UINavigationController) -> MypageCoordinating {
        
        let mypageFactory = MypageFactoryImpl()
        let alarmFactory = AlarmSettingFactoryImpl()
        let changeUniversityFactory = ChangeUniversityFactoryImpl()
        
        return MypageCoordinator(
            navigationController: navigationController,
            mypageFactory: mypageFactory,
            alarmFactory: alarmFactory,
            changeUniversityFactory: changeUniversityFactory
        )
    }
}
