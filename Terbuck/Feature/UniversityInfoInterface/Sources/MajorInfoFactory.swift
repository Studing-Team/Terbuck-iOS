//
//  MajorInfoFactory.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 8/26/25.
//

import UIKit

public protocol MajorInfoFactory {
    func makeMajorInfoViewController(
        type: UniversityType,
        universityName: String,
        coordinator: UniversityInfoCoordinating
    ) -> UIViewController
}
