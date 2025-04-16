//
//  UniversityFactoryImpl.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import UIKit

public protocol UniversityFactory {
    func makeUniversityViewController(coordinator: AuthCoordinator) -> UIViewController
}

public final class UniversityFactoryImpl: UniversityFactory {
    public init() {}

    public func makeUniversityViewController(coordinator: AuthCoordinator) -> UIViewController {
        return UniversityInfoViewController()
    }
}
