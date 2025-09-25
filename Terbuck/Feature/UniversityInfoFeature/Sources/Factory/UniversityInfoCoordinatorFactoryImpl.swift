//
//  UniversityInfoCoordinatorFactoryImpl.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import UIKit

import UniversityInfoInterface

public final class UniversityInfoCoordinatorFactoryImpl: UniversityInfoCoordinatorFactory {
    
    private let universityInfoFactory: UniversityInfoFactory
    private let collegeInfoFactory: CollegeInfoFactory
    
    public init(
        universityInfoFactory: UniversityInfoFactory,
        collegeInfoFactory: CollegeInfoFactory
    ) {
        self.universityInfoFactory = universityInfoFactory
        self.collegeInfoFactory = collegeInfoFactory
    }
    
    public func makeUniversityInfoCoordinator(
        navigationController: UINavigationController,
        initialType: UniversityType
    ) -> UniversityInfoCoordinating {
        return UniversityInfoCoordinator(
            navigationController: navigationController,
            universityInfoFactory: universityInfoFactory,
            collegeInfoFactory: collegeInfoFactory,
            initialType: initialType
        )
    }
}
