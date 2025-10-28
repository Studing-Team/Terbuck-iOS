//
//  PoppableCoordinator.swift
//  Shared
//
//  Created by ParkJunHyuk on 8/27/25.
//

import UIKit

public protocol PoppableCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
    var rootViewController: UIViewController? { get set }
}
