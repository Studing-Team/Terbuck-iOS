//
//  PartnershipModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/28/25.
//

import Foundation
import Shared

public struct PartnershipModel: StoreItemIdentifiable, Hashable {
    var id: String {
        return "\(partnershipName)-\(partnerCategoryType)"
    }
    
    var partnershipName: String
    var partnerCategoryType: PartnerCategoryType
    var storeType: PartnerStoreType
    var isNewPartner: Bool
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.id == rhs.id
    }
}
