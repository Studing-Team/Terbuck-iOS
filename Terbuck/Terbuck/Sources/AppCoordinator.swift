//
//  AppCoordinator.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/15/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import UIKit

import SplashInterface
import AuthInterface
import HomeInterface
import StoreInterface
import MypageInterface
import Shared
import DesignSystem
import CoreKeyChain

final class AppCoordinator: Coordinator {
    var childCoordinators: [any Shared.Coordinator] = []
    
    private var window: UIWindow
    private var navigationController: UINavigationController
    private let splashFactory: SplashFactory
    private let authFactory: AuthFactory
    private let homeTabFactory: HomeTabFactory
    private let storeTabFactory: StoreTabFactory
    private let mypageTabFactory: MypageTabFactory
    
    init(
        window: UIWindow,
        navigationController: UINavigationController,
        splashFactory: SplashFactory,
        authFactory: AuthFactory,
        homeTabFactory: HomeTabFactory,
        storeTabFactory: StoreTabFactory,
        mypageTabFactory: MypageTabFactory
    ) {
        self.window = window
        self.navigationController = navigationController
        self.splashFactory = splashFactory
        self.authFactory = authFactory
        self.homeTabFactory = homeTabFactory
        self.storeTabFactory = storeTabFactory
        self.mypageTabFactory = mypageTabFactory
    }
    
    func start() {
        showSplash()
    }
    
    private func showSplash() {
        let splashCoordinator = splashFactory.makeSplashCoordinator(window: window)
        splashCoordinator.delegate = self
        childCoordinators.append(splashCoordinator)
        splashCoordinator.start()
    }
    
    func showLoginFlow() {
        childCoordinators.removeAll()
        navigationController.viewControllers.removeAll()

        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.window.rootViewController = self.navigationController
                        },
                          completion: nil)
        
        let authCoordinator = authFactory.makeAuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func showMainFlow() {
        childCoordinators.removeAll()
        navigationController.viewControllers.removeAll()
        
        let tabBarController = CustomTabBarController()

        window.rootViewController = tabBarController
        
        let mainCoordinator = MainCoordinator(
            tabBarController: tabBarController,
            homeTabFactory: homeTabFactory,
            storeTabFactory: storeTabFactory,
            mypageTabFactory: mypageTabFactory
        )

        mainCoordinator.delegate = self
        
        // 3. childCoordinators 등록
        childCoordinators.append(mainCoordinator)

        mainCoordinator.start()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didFinishAuthFlow() {
        showMainFlow()
    }
}

extension AppCoordinator: notAuthCoordinatorDelegate {
    func moveLoginFlow() {
        showLoginFlow()
    }
}

extension AppCoordinator: SplashCoordinatorDelegate {
    func splashCoordinatorDidFinish(shouldShowLogin: Bool) {
        if shouldShowLogin {
            showLoginFlow()
        } else {
            showMainFlow()
        }
    }
}
