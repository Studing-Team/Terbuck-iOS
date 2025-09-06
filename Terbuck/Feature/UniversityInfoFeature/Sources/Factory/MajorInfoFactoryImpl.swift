//
//  MajorInfoFactoryImpl.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/27/25.
//

import UIKit
import UniversityInfoInterface

public final class MajorInfoFactoryImpl: MajorInfoFactory {
    
    public init() {}
    
    public func makeMajorInfoViewController(
        type: UniversityType,
        universityName: String,
        coordinator: UniversityInfoCoordinating
    ) -> UIViewController {
        
        let viewModel: MajorInfoViewModel
        
        switch type {
        case .edit:
            viewModel = MajorInfoViewModel(
                selectedUniversityName: universityName,
                editUniversityUseCase: EditUniversityUseCaseImpl(repository: UniversityRepositoryImpl())
            )
            
        case .register:
            viewModel = MajorInfoViewModel(
                selectedUniversityName: universityName,
                signupUseCase: SignupUseCaseImpl(repository: UniversityRepositoryImpl())
            )
        }
        
        return MajorInfoViewController(
            type: type,
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
