//
//  Coordinator.swift
//  Shared
//
//  Created by ParkJunHyuk on 4/15/25.
//

import Foundation

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

public protocol ImagePreviewCoordinating: AnyObject {
    func showPreviewImage(vm: PreviewImageDisplayable)
}

public protocol AuthCoordinatorDelegate: AnyObject {
    func didFinishAuthFlow()
}
