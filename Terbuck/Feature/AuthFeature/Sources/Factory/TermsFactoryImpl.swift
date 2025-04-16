//
//  TermsFactoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit

public protocol TermsFactory {
    func makeTermsViewController(coordinator: AuthCoordinator) -> UIViewController
}

public final class TermsOfServiceFactoryImpl: TermsFactory {
    public init() {}

    public func makeTermsViewController(coordinator: AuthCoordinator) -> UIViewController {
        return TermsOfServiceViewController()
    }
}
