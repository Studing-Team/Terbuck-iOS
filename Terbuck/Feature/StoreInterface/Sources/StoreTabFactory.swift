//
//  StoreTabFactory.swift
//  StoreInterface
//
//  Created by ParkJunHyuk on 5/13/25.
//

import UIKit

public protocol StoreTabFactory {
    func makeStoreCoordinator(navigationController: UINavigationController) -> StoreCoordinating
}
