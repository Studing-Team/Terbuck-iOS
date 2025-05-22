//
//  SearchStoreFactoryImpl.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/21/25.
//

import UIKit
import StoreInterface

public protocol SearchStoreFactory {
    func makeSearchStoreViewController(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator
    ) -> UIViewController
}

public final class SearchStoreFactoryImpl: SearchStoreFactory {
    public init() {}

    public func makeSearchStoreViewController(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator
    ) -> UIViewController {
        return SearchStoreViewController(
            storeMapViewModel: storeMapViewModel,
            coordinator: coordinator
        )
    }
}
