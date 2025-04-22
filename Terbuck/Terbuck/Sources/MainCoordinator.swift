//
//  MainCoordinator.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/19/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import UIKit

import MypageInterface
import Shared

final class MainCoordinator: Coordinator {
    var childCoordinators: [any Shared.Coordinator] = []
    
    private var tabBarController: UITabBarController
    private let mypageTabFactory: MypageTabFactory
    
    init(
        tabBarController: UITabBarController,
        mypageTabFactory: MypageTabFactory
    ) {
        self.tabBarController = tabBarController
        self.mypageTabFactory = mypageTabFactory
    }
    
    func start() {
        let myPageNav = UINavigationController()
        
        myPageNav.setNavigationBarHidden(true, animated: false)
        
        let mypageCoordinator = mypageTabFactory.makeMypageCoordinator(navigationController: myPageNav)
        
        childCoordinators.append(mypageCoordinator)
        
        mypageCoordinator.start()
        tabBarController.viewControllers = [myPageNav]
    }
}
