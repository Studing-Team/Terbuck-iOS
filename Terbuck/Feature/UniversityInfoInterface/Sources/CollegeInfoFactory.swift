//
//  CollegeInfoFactory.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 8/26/25.
//

import UIKit

public protocol CollegeInfoFactory {
    func makeCollegeInfoViewController(
        type: UniversityType,
        universityName: String,
        coordinator: UniversityInfoCoordinating
    ) -> UIViewController
}
