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
    private let collegeInfoFactory: CollegeInfoFactory
    
    private let initialType: UniversityType
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        universityInfoFactory: UniversityInfoFactory,
        collegeInfoFactory: CollegeInfoFactory,
        initialType: UniversityType
    ) {
        self.navigationController = navigationController
        self.universityInfoFactory = universityInfoFactory
        self.collegeInfoFactory = collegeInfoFactory
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
        navigationController.pushViewController(universityInfoVC, animated: true)
    }
    
    func showCollege(selectUniversityName: String) {
        let majorInfoVC = collegeInfoFactory.makeCollegeInfoViewController(
            type: initialType,
            universityName: selectUniversityName,
            coordinator: self
        )
        
        navigationController.pushViewController(majorInfoVC, animated: true)
    }
    
    func didFinishUniversityInfo() {
        delegate?.didFinishUniversityInfo(coordinator: self, initialType: self.initialType)
    }
    
    func backNavigation() {
        navigationController.popViewController(animated: true)
    }
}
