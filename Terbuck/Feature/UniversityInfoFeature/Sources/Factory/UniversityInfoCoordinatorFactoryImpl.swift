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
    private let majorInfoFactory: MajorInfoFactory
    
    public init(
        universityInfoFactory: UniversityInfoFactory,
        majorInfoFactory: MajorInfoFactory
    ) {
        self.universityInfoFactory = universityInfoFactory
        self.majorInfoFactory = majorInfoFactory
    }
    
    public func makeUniversityInfoCoordinator(
        navigationController: UINavigationController,
        initialType: UniversityType
    ) -> UniversityInfoCoordinating {
        return UniversityInfoCoordinator(
            navigationController: navigationController,
            universityInfoFactory: universityInfoFactory,
            majorInfoFactory: majorInfoFactory,
            initialType: initialType
        )
    }
}
