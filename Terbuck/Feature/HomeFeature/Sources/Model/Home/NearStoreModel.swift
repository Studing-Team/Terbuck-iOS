//
//  NearStoreModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Foundation
import DesignSystem
import Shared

public struct NearStoreModel: Identifiable, Hashable {
    public var id: Int
    var storeName: String
    var category: CategoryType
    var address: String
    var benefitData: [StoreBenefitsModel]
}
