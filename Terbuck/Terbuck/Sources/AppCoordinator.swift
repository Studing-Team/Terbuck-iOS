//
//  AppCoordinator.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/15/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import UIKit

import AuthInterface
import Shared

final class AppCoordinator: Coordinator {
    var childCoordinators: [any Shared.Coordinator] = []
    
    private var navigationController: UINavigationController
    private let authFactory: AuthFactory
    
    init(
        navigationController: UINavigationController,
        authFactory: AuthFactory
    ) {
        self.navigationController = navigationController
        self.authFactory = authFactory
    }
    
    func start() {
        showLoginFlow()
    }
    
    func showLoginFlow() {
        let authCoordinator = authFactory.makeAuthCoordinator(navigationController: navigationController)
        
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
}
