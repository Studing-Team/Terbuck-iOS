//
//  UniversityFactoryImpl.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 7/9/25.
//

import UIKit

import UniversityInfoInterface

public final class UniversityInfoFactoryImpl: UniversityInfoFactory {
    
    public init() {}

    public func makeUniversityInfoViewController(type: UniversityType, coordinator: UniversityInfoCoordinating, onFinish: @escaping () -> Void) -> UIViewController {
        
        let viewModel: UniversityViewModel
        
        switch type {
        case .edit:
            viewModel = UniversityViewModel(
                editUniversityUseCase: EditUniversityUseCaseImpl(repository: UniversityRepositoryImpl())
            )
        case .register:
            viewModel = UniversityViewModel(
                signupUseCase: SignupUseCaseImpl(repository: UniversityRepositoryImpl())
            )
        }
        
        return UniversityViewController(
            type: type,
            viewModel: viewModel,
            coordinator: coordinator,
            onFinish: onFinish
        )
    }
}
