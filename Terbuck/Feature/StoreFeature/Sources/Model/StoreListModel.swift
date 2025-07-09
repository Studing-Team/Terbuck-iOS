//
//  StoreListModel.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/13/25.
//

import Foundation

import DesignSystem

public struct StoreListModel: Identifiable, Hashable {
    public var id: Int
    let imageURL: String
    let storeName: String
    let storeAddress: String
    let category: CategoryType
    let benefitCount: Int
    let latitude: Double
    let longitude: Double
}
