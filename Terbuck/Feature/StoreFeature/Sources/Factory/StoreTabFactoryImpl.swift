//
//  StoreTabFactoryImpl.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/13/25.
//

import UIKit
import StoreInterface

public final class StoreTabFactoryImpl: StoreTabFactory {
    
    public init() {}
    
    public func makeStoreCoordinator(navigationController: UINavigationController) -> StoreCoordinating {
        
        let storeMapFactory = StoreMapFactoryImpl()
        let storeModalFactory = StoreModalFactoryImpl()
        let detailStoreFactoryImpl = DetailStoreFactoryImpl()
        let searchStoreFactory = SearchStoreFactoryImpl()
        
        return StoreCoordinator(
            navigationController: navigationController,
            storeMapFactory: storeMapFactory,
            storeModalFactory: storeModalFactory,
            detailStoreFactory: detailStoreFactoryImpl,
            searchStoreFactory: searchStoreFactory
        )
    }
}
