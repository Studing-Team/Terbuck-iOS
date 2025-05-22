//
//  DetailStoreFactoryImpl.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import UIKit
import StoreInterface

public protocol DetailStoreFactory {
    func makeDetailStoreViewController(coordinator: StoreCoordinator) -> UIViewController
}

public final class DetailStoreFactoryImpl: DetailStoreFactory {

    public init() {}

    public func makeDetailStoreViewController(coordinator: StoreCoordinator) -> UIViewController {
        
        return DetailStoreInfoViewController(
            detailStoreViewModel: DetailStoreInfoViewModel(),
            coordinator: coordinator
        )
    }
}
