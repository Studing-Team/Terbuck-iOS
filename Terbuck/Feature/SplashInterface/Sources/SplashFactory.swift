//
//  SplashFactory.swift
//  AuthInterface
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit

public protocol SplashFactory {
    func makeSplashCoordinator(window: UIWindow) -> SplashCoordinating
}
