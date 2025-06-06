//
//  ChangeUniversityFactoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import UIKit
import MypageInterface

public protocol ChangeUniversityFactory {
    func makeChangeUniversityViewController(coordinator: MypageCoordinator) -> UIViewController
}

public final class ChangeUniversityFactoryImpl: ChangeUniversityFactory {

    public init() {}

    public func makeChangeUniversityViewController(coordinator: MypageCoordinator) -> UIViewController {
        
        let viewModel = ChangeUniversityViewModel(
            changeUniversityUseCase: ChangeUniversityUseCaseImpl(repository: MemberRepositoryImpl())
        )
        
        return ChangeUniversityViewController(
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
