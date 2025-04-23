//
//  HomeTabFactory.swift
//  HomeInterface
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit

public protocol HomeTabFactory {
    func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinating
}
