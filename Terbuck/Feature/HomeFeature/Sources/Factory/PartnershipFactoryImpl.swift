//
//  PartnershipFactoryImpl.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/28/25.
//

import UIKit
import HomeInterface

public protocol PartnershipFactory {
    func makePartnershipViewController(
        coordinator: HomeCoordinator,
        partnershipId: Int
    ) -> UIViewController
}

public final class PartnershipFactoryImpl: PartnershipFactory {

    public init() {}

    public func makePartnershipViewController(
        coordinator: HomeCoordinator,
        partnershipId: Int
    ) -> UIViewController {
        let viewModel = PartnershipViewModel(
            detailPartnershipUseCase: DetailPartnershipUseCaseImpl(repository: HomeRepositoryImpl()),
            partnershipId: partnershipId
        )
        
        return PartnershipViewController(
            partnershipViewModel: viewModel,
            coordinator: coordinator
        )
    }
}
