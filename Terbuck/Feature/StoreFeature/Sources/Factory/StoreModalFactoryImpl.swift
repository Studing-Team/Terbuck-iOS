//
//  StoreModalFactoryImpl.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import UIKit
import StoreInterface

public protocol StoreModalFactory {
    func makeStoreModalViewController(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator
    ) -> UIViewController
}

public final class StoreModalFactoryImpl: StoreModalFactory {
    public init() {}

    public func makeStoreModalViewController(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator
    ) -> UIViewController {
        return StoreListModalViewController(
            storeMapViewModel: storeMapViewModel,
            coordinator: coordinator,
            type: .verticalList
        )
    }
}
