//
//  HomeTabFactoryImpl.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit
import HomeInterface

public final class HomeTabFactoryImpl: HomeTabFactory {
    
    public init() {}
    
    public func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinating {
        
        let homeFactory = HomeFactoryImpl()
        
        return HomeCoordinator(
            navigationController: navigationController,
            homeFactory: homeFactory
        )
    }
}
