//
//  TermsFactoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit

public protocol TermsFactory {
    func makeTermsViewController(coordinator: AuthCoordinator, viewModel: TermsOfServiceViewModel) -> UIViewController
    func makeTermsViewModel() -> TermsOfServiceViewModel
}

public final class TermsOfServiceFactoryImpl: TermsFactory {
    public init() {}

    public func makeTermsViewController(coordinator: AuthCoordinator, viewModel: TermsOfServiceViewModel) -> UIViewController {
        return TermsOfServiceViewController(viewModel: makeTermsViewModel(), coordinator: coordinator)
    }
    
    public func makeTermsViewModel() -> TermsOfServiceViewModel {
        return TermsOfServiceViewModel()
    }
}
