//
//  RegisterStudentCardCoordinatorDelegate.swift
//  RegisterStudentCardInterface
//
//  Created by ParkJunHyuk on 7/18/25.
//

import Foundation
import Shared

public protocol RegisterStudentCardCoordinatorDelegate: AnyObject {
    func didFinishRegisterStudentCard(coordinator: Coordinator)
}
