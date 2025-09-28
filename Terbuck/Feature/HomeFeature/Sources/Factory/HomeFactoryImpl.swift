//
//  HomeFactoryImpl.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit
import HomeInterface

public protocol HomeFactory {
    func makeHomeViewController(coordinator: HomeCoordinator) -> UIViewController
}

public final class HomeFactoryImpl: HomeFactory {

    public init() {}

    public func makeHomeViewController(coordinator: HomeCoordinator) -> UIViewController {
        let viewModel = HomeViewModel(
            searchStoreUseCase: SearchStoreUseCaseImpl(repository: HomeRepositoryImpl()),
            searchPartnershipUseCase: SearchPartnershipUseCaseImpl(repository: HomeRepositoryImpl()),
            fetchPartnershipDisclosureStatusUseCase: FetchPartnershipDisclosureStatusUseCaseImpl(repository: HomeRepositoryImpl()),
            requestPartnershipDisclosureUseCase: RequestPartnershipDisclosureUseCaseImpl(repository: HomeRepositoryImpl()),
            fetchDisclosureRequestStatusUseCase: FetchDisclosureRequestStatusUseCaseImpl(repository: HomeRepositoryImpl()),
            fetchApprovedStudentIdStatusUseCase: FetchApprovedStudentIdStatusUseCaseImpl(repository: HomeRepositoryImpl())
        )
        
        return HomeViewController(
            homeViewModel: viewModel,
            coordinator: coordinator
        )
    }
}
