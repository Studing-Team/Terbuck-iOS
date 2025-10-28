//
//  UniversityInfoFactory.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 7/9/25.
//

import UIKit

public protocol UniversityInfoFactory {
    func makeUniversityInfoViewController(
        type: UniversityType,
        coordinator: UniversityInfoCoordinating
    ) -> UIViewController
}
