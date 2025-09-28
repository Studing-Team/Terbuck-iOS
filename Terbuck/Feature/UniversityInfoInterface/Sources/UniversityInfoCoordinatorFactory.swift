//
//  UniversityInfoCoordinatorFactory.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 8/27/25.
//

import UIKit

public protocol UniversityInfoCoordinatorFactory {
    func makeUniversityInfoCoordinator(
        navigationController: UINavigationController,
        initialType: UniversityType
    ) -> UniversityInfoCoordinating
}
