//
//  UniversityInfoCoordinatorDelegate.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 8/26/25.
//

import Foundation
import Shared

public protocol UniversityInfoCoordinatorDelegate: AnyObject {
    func didFinishUniversityInfo(coordinator: Coordinator, initialType: UniversityType)
}
