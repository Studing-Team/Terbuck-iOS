//
//  AuthFactory.swift
//  AuthInterface
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit

public protocol AuthFactory {
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinating
}
