//
//  CurrentSearchModel.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/21/25.
//

import Foundation

import DesignSystem

public struct CurrentSearchModel: Identifiable, Hashable {
    public var id: String {
        return "\(storeName)"
    }
    
    let storeName: String
}
