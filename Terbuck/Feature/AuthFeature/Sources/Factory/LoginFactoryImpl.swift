//
//  LoginFactoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit

public protocol LoginFactory {
    func makeLoginViewController(coordinator: AuthCoordinator) -> UIViewController
}

public final class LoginFactoryImpl: LoginFactory {
    public init() {}

    public func makeLoginViewController(coordinator: AuthCoordinator) -> UIViewController {
        let viewModel = LoginViewModel()
        
        return LoginViewController(viewModel: viewModel, coordinator: coordinator)
    }
}
