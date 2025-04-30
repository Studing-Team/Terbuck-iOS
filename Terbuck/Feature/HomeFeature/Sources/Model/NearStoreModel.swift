//
//  NearStoreModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Foundation
import Shared

public struct NearStoreModel: Identifiable, Hashable {
    public var id: String {
        return "\(storeName)-\(address)"
    }

    var storeName: String
    var cateotry: CategoryType
    var address: String
    var mainBenefit: String
    var subBenefit: [String]? = nil
}
