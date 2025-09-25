//
//  CollegeInfoFactoryImpl.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/27/25.
//

import UIKit
import UniversityInfoInterface

public final class CollegeInfoFactoryImpl: CollegeInfoFactory {
    
    public init() {}
    
    public func makeCollegeInfoViewController(
        type: UniversityType,
        universityName: String,
        coordinator: UniversityInfoCoordinating
    ) -> UIViewController {
        
        let viewModel: CollegeInfoViewModel
        
        switch type {
        case .edit:
            viewModel = CollegeInfoViewModel(
                selectedUniversityName: universityName,
                fetchCollegesInfoListUseCase: FetchCollegesInfoListUseCaseImpl(repository: UniversityRepositoryImpl()),
                editUniversityUseCase: EditUniversityUseCaseImpl(repository: UniversityRepositoryImpl())
            )
            
        case .register:
            viewModel = CollegeInfoViewModel(
                selectedUniversityName: universityName,
                fetchCollegesInfoListUseCase: FetchCollegesInfoListUseCaseImpl(repository: UniversityRepositoryImpl()),
                signupUseCase: SignupUseCaseImpl(repository: UniversityRepositoryImpl())
            )
        }
        
        return CollegeInfoViewController(
            type: type,
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
