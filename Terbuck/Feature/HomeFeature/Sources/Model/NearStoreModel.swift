//
//  NearStoreModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Foundation
import Shared

public struct NearStoreModel: StoreItemIdentifiable, Hashable {
    var id: String {
        return "\(storeName)-\(address)"
    }
    
    var storeName: String
    var cateotry: CategoryType
    var address: String
    var mainBenefit: String
    var subBenefit: [String]? = nil
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.id == rhs.id
    }
}

protocol StoreItemIdentifiable: Hashable {
    var id: String { get } // 고유 식별자
}
