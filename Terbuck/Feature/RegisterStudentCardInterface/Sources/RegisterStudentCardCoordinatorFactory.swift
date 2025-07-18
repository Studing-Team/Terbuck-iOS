//
//  RegisterStudentCardCoordinatorFactory.swift
//  RegisterStudentCardInterface
//
//  Created by ParkJunHyuk on 7/10/25.
//

import UIKit

public protocol RegisterStudentCardCoordinatorFactory {
    func makeRegisterStudentCardCoordinator(navigationController: UINavigationController, initialType: AuthStudentType, initialLocation: CGRect?) -> RegisterStudentCardCoordinating
}
