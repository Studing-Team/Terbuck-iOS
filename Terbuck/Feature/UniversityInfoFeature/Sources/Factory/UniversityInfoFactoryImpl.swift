//
//  UniversityInfoFactoryImpl.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 7/9/25.
//

import UIKit
import UniversityInfoInterface

public final class UniversityInfoFactoryImpl: UniversityInfoFactory {
    
    private let getUniversityInfoListUseCaseFactory: any GetUniversityInfoListUseCaseFactory
    
    public init(getUniversityInfoListUseCaseFactory: any GetUniversityInfoListUseCaseFactory) {
        self.getUniversityInfoListUseCaseFactory = getUniversityInfoListUseCaseFactory
    }

    public func makeUniversityInfoViewController(
        type: UniversityType,
        coordinator: UniversityInfoCoordinating
    ) -> UIViewController {
        
        let viewModel = UniversityViewModel(
            getUniversityInfoListUseCase: getUniversityInfoListUseCaseFactory.makeGetUniversityInfoListUseCase()
        )

        return UniversityViewController(
            type: type,
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
