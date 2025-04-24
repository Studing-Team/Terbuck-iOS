//
//  MainCoordinator.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/19/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import UIKit

import HomeInterface
import MypageInterface
import DesignSystem
import Shared

final class MainCoordinator: Coordinator {
    var childCoordinators: [any Shared.Coordinator] = []
    
    private var tabBarController: UITabBarController
    private let homeTabFactory: HomeTabFactory
    private let mypageTabFactory: MypageTabFactory
    
    init(
        tabBarController: UITabBarController,
        homeTabFactory: HomeTabFactory,
        mypageTabFactory: MypageTabFactory
    ) {
        self.tabBarController = tabBarController
        self.homeTabFactory = homeTabFactory
        self.mypageTabFactory = mypageTabFactory
    }
    
    func start() {
        let homeNav = UINavigationController()
        let storeNav = UINavigationController()
        let myPageNav = UINavigationController()
        
        homeNav.setNavigationBarHidden(true, animated: false)
        storeNav.setNavigationBarHidden(true, animated: false)
        myPageNav.setNavigationBarHidden(true, animated: false)
        
        let homeCoordinator = homeTabFactory.makeHomeCoordinator(navigationController: homeNav)
        let mypageCoordinator = mypageTabFactory.makeMypageCoordinator(navigationController: myPageNav)
        
        childCoordinators.append(homeCoordinator)
        childCoordinators.append(mypageCoordinator)
        
        homeCoordinator.start()
        mypageCoordinator.start()
        tabBarController.viewControllers = [homeNav, storeNav, myPageNav]
        
        if let customTabBarVC = tabBarController as? CustomTabBarController {
            customTabBarVC.customTabBarView.onTabSelected = { [weak self] (tabType: TabBarType) in
                switch tabType {
                case .home: self?.tabBarController.selectedIndex = 0
                case .store: self?.tabBarController.selectedIndex = 1
                case .mypage: self?.tabBarController.selectedIndex = 2
                }
            }
        }
    }
}
