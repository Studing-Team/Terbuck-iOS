//
//  RegisterStudentCardFactory.swift
//  RegisterStudentCardInterface
//
//  Created by ParkJunHyuk on 7/9/25.
//

import UIKit
import Foundation

public protocol RegisterStudentCardFactory {
    func makeRegisterStudentCardViewController(coordinator: RegisterStudentCardCoordinating) -> UIViewController
    func makeStudentIdCardViewController(type: AuthStudentUIType, location: CGRect?, coordinator: RegisterStudentCardCoordinating) -> UIViewController
}
