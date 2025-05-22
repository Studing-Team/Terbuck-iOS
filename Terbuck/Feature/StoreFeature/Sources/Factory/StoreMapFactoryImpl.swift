//
//  StoreMapFactoryImpl.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/13/25.
//

import UIKit
import StoreInterface

public protocol StoreMapFactory {
    func makeStoreMapViewController(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator
    ) -> UIViewController
}

public final class StoreMapFactoryImpl: StoreMapFactory {
    public init() {}

    public func makeStoreMapViewController(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator
    ) -> UIViewController {
        return StoreMapViewController(
            storeMapViewModel: storeMapViewModel,
            coordinator: coordinator
        )
    }
}
