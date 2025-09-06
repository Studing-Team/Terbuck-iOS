//
//  UniversityInfoFactoryImpl.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 7/9/25.
//

import UIKit
import UniversityInfoInterface

public final class UniversityInfoFactoryImpl: UniversityInfoFactory {
    
    public init() {}

    public func makeUniversityInfoViewController(
        type: UniversityType,
        coordinator: UniversityInfoCoordinating
    ) -> UIViewController {
        
        let viewModel = UniversityViewModel(
            fetchUniversityInfoListUseCase: FetchUniversityInfoListUseCaseImpl(repository: UniversityRepositoryImpl())
        )

        return UniversityViewController(
            type: type,
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
