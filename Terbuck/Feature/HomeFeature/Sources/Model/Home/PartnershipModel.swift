//
//  PartnershipModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/28/25.
//

import Foundation
import Shared

public struct PartnershipModel: Identifiable, Hashable {
    public var id: Int
    var partnershipName: String
    var partnerCategoryType: PartnerCategoryType
    var storeType: PartnerStoreType
    var isNewPartner: Bool
}
