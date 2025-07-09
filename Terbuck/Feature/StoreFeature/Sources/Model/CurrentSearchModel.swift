//
//  CurrentSearchModel.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/21/25.
//

import Foundation

import DesignSystem

public struct CurrentSearchModel: Identifiable, Hashable, Codable {
    public var id: Int
    let storeName: String
    let searchDate: Date
}
