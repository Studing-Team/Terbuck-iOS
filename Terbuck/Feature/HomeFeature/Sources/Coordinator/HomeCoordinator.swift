//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import UIKit

import HomeInterface
import Shared

public class HomeCoordinator: HomeCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let homeFactory: HomeFactory
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        homeFactory: HomeFactory
    ) {
        self.navigationController = navigationController
        self.homeFactory = homeFactory
    }
    
    // MARK: - Method
    
    public func start() {
        startHome()
    }
    
    public func startHome() {
        let homeVC = homeFactory.makeHomeViewController(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
    }
}
