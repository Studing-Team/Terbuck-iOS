//
//  RegisterStudentCardFactoryImpl.swift
//  RegisterStudentCardFeature
//
//  Created by ParkJunHyuk on 7/9/25.
//

import UIKit

import RegisterStudentCardInterface

public final class RegisterStudentCardFactoryImpl: RegisterStudentCardFactory {

    public init() {}

    public func makeRegisterStudentCardViewController(coordinator: RegisterStudentCardCoordinating) -> UIViewController {
        
        let viewModel = RegisterStudentCardViewModel(
            registerStudentIDUseCase: RegisterStudentIDUseCaseImpl(repository: RegisterRepositoryImpl())
        )
        
        return RegisterStudentCardViewController(
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
    
    public func makeStudentIdCardViewController(
        type: AuthStudentUIType,
        location: CGRect? = nil,
        coordinator: RegisterStudentCardCoordinating
    ) -> UIViewController {
        
        return StudentIDCardViewController(
            authType: type,
            location: location,
            coordinator: coordinator,
            viewModel: StudentIdCardViewModel()
        )
    }
}
