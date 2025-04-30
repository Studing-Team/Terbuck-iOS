//
//  PartnershipModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/28/25.
//

import Foundation
import Shared

public struct PartnershipModel: Identifiable, Hashable {
    public var id: String {
        return "\(partnershipName) - \(partnerCategoryType)"
    }
    
    var partnershipName: String
    var partnerCategoryType: PartnerCategoryType
    var storeType: PartnerStoreType
    var isNewPartner: Bool
}
