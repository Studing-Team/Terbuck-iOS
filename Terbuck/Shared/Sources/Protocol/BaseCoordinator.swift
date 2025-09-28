
//
//  BaseCoordinator.swift
//  Shared
//
//  Created by ParkJunHyuk on 8/30/25.
//

import UIKit

open class BaseCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    public var childCoordinators: [Coordinator] = []
    public let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    open func start() {
        // This method should be overridden by subclasses
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let coordinator = childCoordinators.first(where: { ($0 as? PoppableCoordinator)?.rootViewController == fromViewController }) {
            childCoordinators = childCoordinators.filter { $0 !== coordinator }
        }
    }
}
