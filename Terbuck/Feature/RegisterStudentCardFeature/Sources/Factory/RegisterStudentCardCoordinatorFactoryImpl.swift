//
//  RegisterStudentCardCoordinatorFactoryImpl.swift
//  RegisterStudentCardFeature
//
//  Created by ParkJunHyuk on 7/10/25.
//

import UIKit

import RegisterStudentCardInterface

public final class RegisterStudentCardCoordinatorFactoryImpl: RegisterStudentCardCoordinatorFactory {
    
    private let registerStudentCardFactory: RegisterStudentCardFactory
    
    public init(
        registerStudentCardFactory: RegisterStudentCardFactory
    ) {
        self.registerStudentCardFactory = registerStudentCardFactory
    }

    public func makeRegisterStudentCardCoordinator(navigationController: UINavigationController, initialType: AuthStudentType, initialLocation: CGRect?
) -> RegisterStudentCardCoordinating {
        return RegisterStudentCardCoordinator(
            navigationController: navigationController,
            registerStudentCardFactory: registerStudentCardFactory,
            initialType: initialType,
            initialLocation: initialLocation
        )
    }
}
