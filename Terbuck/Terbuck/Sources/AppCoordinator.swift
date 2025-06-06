//
//  AppCoordinator.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/15/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import UIKit

import AuthInterface
import HomeInterface
import StoreInterface
import MypageInterface
import Shared
import DesignSystem
import CoreKeyChain

final class AppCoordinator: Coordinator {
    var childCoordinators: [any Shared.Coordinator] = []
    
    private var navigationController: UINavigationController
    private let authFactory: AuthFactory
    private let homeTabFactory: HomeTabFactory
    private let storeTabFactory: StoreTabFactory
    private let mypageTabFactory: MypageTabFactory
    
    init(
        navigationController: UINavigationController,
        authFactory: AuthFactory,
        homeTabFactory: HomeTabFactory,
        storeTabFactory: StoreTabFactory,
        mypageTabFactory: MypageTabFactory
    ) {
        self.navigationController = navigationController
        self.authFactory = authFactory
        self.homeTabFactory = homeTabFactory
        self.storeTabFactory = storeTabFactory
        self.mypageTabFactory = mypageTabFactory
    }
    
    func start() {
        if let token = KeychainManager.shared.load(key: .accessToken), !token.isEmpty {
            showMainFlow()
        } else {
            showLoginFlow()
        }
    }
    
    func showLoginFlow() {
        let authCoordinator = authFactory.makeAuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func showMainFlow() {
        // 1. 기존 child 제거 (ex. 로그인 Coordinator 종료)
        childCoordinators.removeAll()
        navigationController.viewControllers.removeAll()
        
        // 2. TabBarController 생성
        let tabBarController = CustomTabBarController()
        
        // 3. 현재 window의 rootViewController를 TabBarController로 변경
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarController
        }

        // 2. 새로운 NavigationController (or 각 탭의 Nav 구성)
        let mainCoordinator = MainCoordinator(
            tabBarController: tabBarController,
            homeTabFactory: homeTabFactory,
            storeTabFactory: storeTabFactory,
            mypageTabFactory: mypageTabFactory
        )

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
