//
//  SplashCoordinator.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import UIKit

import SplashInterface
import Shared

public final class SplashCoordinator: SplashCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    public weak var delegate: SplashCoordinatorDelegate?
    
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func start() {
        let splashVC = SplashViewController()
        splashVC.delegate = self
        window.rootViewController = splashVC
    }
}

extension SplashCoordinator: SplashViewControllerDelegate {
    public func splashDidFinish(shouldShowLogin: Bool) {
        delegate?.splashCoordinatorDidFinish(shouldShowLogin: shouldShowLogin)
    }
}
