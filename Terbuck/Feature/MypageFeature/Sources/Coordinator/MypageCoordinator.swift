//
//  MypageCoordinator.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit

import MypageInterface
import NotificationSettingInterface
import RegisterStudentCardInterface
import UniversityInfoInterface
import Shared

public class MypageCoordinator: NSObject, MypageCoordinating {

    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    public var rootViewController: UIViewController?
    
    private let mypageFactory: MypageFactory
    private let alarmSettingFactory: AlarmSettingFactory
    private let universityInfoCoordinatorFactory: UniversityInfoCoordinatorFactory
    private let registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    
    public weak var delegate: notAuthCoordinatorDelegate?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        mypageFactory: MypageFactory,
        alarmSettingFactory: AlarmSettingFactory,
        universityInfoCoordinatorFactory: UniversityInfoCoordinatorFactory,
        registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    ) {
        self.navigationController = navigationController
        self.mypageFactory = mypageFactory
        self.alarmSettingFactory = alarmSettingFactory
        self.universityInfoCoordinatorFactory = universityInfoCoordinatorFactory
        self.registerStudentCardFactory = registerStudentCardFactory
        super.init()
        
        self.navigationController.delegate = self
    }
    
    // MARK: - Method
    
    public func start() {
        startMypage()
    }
    
    public func startMypage() {
        let mypageVC = mypageFactory.makeMypageViewController(coordinator: self)
        navigationController.pushViewController(mypageVC, animated: true)
    }
    
    public func startRegisterStudentCard(for type: AuthStudentType, location: CGRect?) {
        let registerCoordinator = registerStudentCardFactory.makeRegisterStudentCardCoordinator(
            navigationController: self.navigationController,
            initialType: type,
            initialLocation: location
        )

        registerCoordinator.delegate = self
        
        childCoordinators.append(registerCoordinator)
        
        registerCoordinator.start()
    }
    
    public func showUniversity() {
        let universityCoordinator = universityInfoCoordinatorFactory.makeUniversityInfoCoordinator(
            navigationController: self.navigationController,
            initialType: .edit
        )
        
        universityCoordinator.delegate = self
        
        childCoordinators.append(universityCoordinator)
        universityCoordinator.start()
    }
    
    public func moveLoginFlow() {
        delegate?.moveLoginFlow()
    }
}

// MARK: - 알림 Setting Feature

extension MypageCoordinator: AlarmSettingCoordinating {
    public func showAlarmSetting() {
        let alarmSettingVC = alarmSettingFactory.makeAlarmSettingViewController(coordinator: self)
        
        alarmSettingVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(alarmSettingVC, animated: true)
    }
}

// MARK: - 대학교 변경을 위한 Coordinator

extension MypageCoordinator: UniversityInfoCoordinatorDelegate {
    public func didFinishUniversityInfo(coordinator: Coordinator, initialType: UniversityType) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    public func universityInfoCoordinatorDidTapBack(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

// MARK: - 학생증 재등록을 위한 Coordinator

extension MypageCoordinator: RegisterStudentCardCoordinatorDelegate {
    public func didFinishRegisterStudentCard(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

// MARK: - 뒤로가기 제스쳐 관련 로직 (자식 Coordinator 삭제)

extension MypageCoordinator: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let coordinator = childCoordinators.first(where: { ($0 as? PoppableCoordinator)?.rootViewController == fromViewController }) {
            childCoordinators = childCoordinators.filter { $0 !== coordinator }
        }
    }
}
