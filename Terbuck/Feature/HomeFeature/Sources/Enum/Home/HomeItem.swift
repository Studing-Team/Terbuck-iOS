//
//  HomeItem.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/30/25.
//

import Foundation

public enum HomeItem: Hashable {
    case restaurant(NearStoreModel)
    case convenient(NearStoreModel)
    case partnership(PartnershipModel)
}
