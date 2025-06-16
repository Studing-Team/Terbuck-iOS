//
//  NearStoreModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Foundation
import DesignSystem

public struct NearStoreModel: Identifiable, Hashable {
    public var id: Int
    var storeName: String
    var category: CategoryType
    var address: String
    var mainBenefit: String
    var subBenefit: [String]
}
