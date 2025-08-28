//
//  UniversityInfoCoordinator.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/22/25.
//

import UIKit

import UniversityInfoInterface
import Shared

final class UniversityInfoCoordinator: UniversityInfoCoordinating, PoppableCoordinator {
    var childCoordinators: [any Shared.Coordinator] = []
    var rootViewController: UIViewController?
    
    weak var delegate: UniversityInfoCoordinatorDelegate?
    var navigationController: UINavigationController
    
    private let universityInfoFactory: UniversityInfoFactory
    private let majorInfoFactory: MajorInfoFactory
    
    private let initialType: UniversityType
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        universityInfoFactory: UniversityInfoFactory,
        majorInfoFactory: MajorInfoFactory,
        initialType: UniversityType
    ) {
        self.navigationController = navigationController
        self.universityInfoFactory = universityInfoFactory
        self.majorInfoFactory = majorInfoFactory
        self.initialType = initialType
    }
    
    deinit {
        AppLogger.log("UniversityInfoCoordinator Deinit", .info, .ui)
    }
    
    // MARK: - Method
    
    func start() {
        showUniversity()
    }
    
    func showUniversity() {
        let universityInfoVC = universityInfoFactory.makeUniversityInfoViewController(
            type: initialType,
            coordinator: self
        )
        self.rootViewController = universityInfoVC
        
        universityInfoVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(universityInfoVC, animated: true)
    }
    
    func showMajor(selectUniversityName: String) {
        let majorInfoVC = majorInfoFactory.makeMajorInfoViewController(
            type: initialType,
            universityName: selectUniversityName,
            coordinator: self
        )
        
        majorInfoVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(majorInfoVC, animated: true)
    }
    
    func didFinishUniversityInfo() {
        delegate?.didFinishUniversityInfo(coordinator: self, initialType: self.initialType)
    }
    
    func backNavigation() {
        navigationController.popViewController(animated: true)
    }
}
