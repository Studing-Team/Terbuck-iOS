//
//  NearStoreModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Foundation

public struct NearStoreModel: Decodable {
    var storeName: String
    var address: String
    var mainBenefit: String
    var subBenefit: [String]? = nil
}
