//
//  MypageTabFactoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit

import DomainInterface
import MypageInterface
import NotificationSettingInterface
import UniversityInfoInterface
import RegisterStudentCardInterface

public final class MypageTabFactoryImpl: MypageTabFactory {
    
    private let alarmSettingFactory: AlarmSettingFactory
    private let universityInfoCoordinatorFactory: UniversityInfoCoordinatorFactory
    private let registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    private let searchStudentInfoUseCaseFactory: any SearchStudentInfoUseCaseFactory
    private let deleteMemberUseCaseFactory: any DeleteMemberUseCaseFactory
    
    public init(
        alarmSettingFactory: AlarmSettingFactory,
        universityInfoCoordinatorFactory: UniversityInfoCoordinatorFactory,
        registerStudentCardFactory: RegisterStudentCardCoordinatorFactory,
        searchStudentInfoUseCaseFactory: any SearchStudentInfoUseCaseFactory,
        deleteMemberUseCaseFactory: any DeleteMemberUseCaseFactory
    ) {
        self.alarmSettingFactory = alarmSettingFactory
        self.universityInfoCoordinatorFactory = universityInfoCoordinatorFactory
        self.registerStudentCardFactory = registerStudentCardFactory
        self.searchStudentInfoUseCaseFactory = searchStudentInfoUseCaseFactory
        self.deleteMemberUseCaseFactory = deleteMemberUseCaseFactory
    }
    
    public func makeMypageCoordinator(navigationController: UINavigationController) -> MypageCoordinating {
        
        let mypageFactory = MypageFactoryImpl(
            searchStudentInfoUseCaseFactory: searchStudentInfoUseCaseFactory,
            deleteMemberUseCaseFactory: deleteMemberUseCaseFactory
        )
        
        return MypageCoordinator(
            navigationController: navigationController,
            mypageFactory: mypageFactory,
            alarmSettingFactory: alarmSettingFactory,
            universityInfoCoordinatorFactory: universityInfoCoordinatorFactory,
            registerStudentCardFactory: registerStudentCardFactory
        )
    }
}
