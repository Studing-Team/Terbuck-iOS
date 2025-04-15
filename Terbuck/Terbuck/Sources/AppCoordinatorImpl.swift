//
//  AppCoordinatorImpl.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/15/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import UIKit
import AuthFeature
import Shared

final class AppCoordinator: Coordinator {
    var childCoordinators: [any Shared.Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginFlow()
    }
    
    func showLoginFlow() {
        let authCoordinator = AuthCoordinatorImpl(navigationController: navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
}
