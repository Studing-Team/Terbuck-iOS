//
//  CollegeInfoFactoryImpl.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/27/25.
//

import UIKit
import UniversityInfoInterface

public final class CollegeInfoFactoryImpl: CollegeInfoFactory {
    
    private let getCollegesInfoListUseCaseFactory: any GetCollegesInfoListUseCaseFactory
    private let signupUseCaseFactory: any SignupUseCaseFactory
    private let updateUniversityUseCaseFactory: any UpdateUniversityUseCaseFactory
    
    public init(
        getCollegesInfoListUseCaseFactory: any GetCollegesInfoListUseCaseFactory,
        signupUseCaseFactory: any SignupUseCaseFactory,
        updateUniversityUseCaseFactory: any UpdateUniversityUseCaseFactory
    ) {
        self.getCollegesInfoListUseCaseFactory = getCollegesInfoListUseCaseFactory
        self.signupUseCaseFactory = signupUseCaseFactory
        self.updateUniversityUseCaseFactory = updateUniversityUseCaseFactory
    }
    
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
                getCollegesInfoListUseCase: getCollegesInfoListUseCaseFactory.makeGetCollegesInfoListUseCase(),
                updateUniversityUseCase: updateUniversityUseCaseFactory.makeUpdateUniversityUseCase()
            )
            
        case .register:
            viewModel = CollegeInfoViewModel(
                selectedUniversityName: universityName,
                getCollegesInfoListUseCase: getCollegesInfoListUseCaseFactory.makeGetCollegesInfoListUseCase(),
                signupUseCase: signupUseCaseFactory.makeSignupUseCase()
            )
        }
        
        return CollegeInfoViewController(
            type: type,
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
