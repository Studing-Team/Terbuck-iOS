//
//  StoreCoordinating.swift
//  StoreInterface
//
//  Created by ParkJunHyuk on 5/13/25.
//

import Shared

public protocol StoreCoordinating: Coordinator {
    func startStoreMap()
    func presentStoreModal()
    func showDetailStoreInfo()
}
