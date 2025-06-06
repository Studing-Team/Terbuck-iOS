//
//  SearchStoreMapEntity.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import Foundation
import CoreNetwork

public struct SearchStoreMapEntity {
    public let id: Int
    public let name: String
    public let storeImageURL: String
    public let address: String
    public let latitude: Double
    public let longitude: Double
    public let benefitCount: Int
}

extension SearchStoreMapListData {
    func toEntity() -> SearchStoreMapEntity {
        return SearchStoreMapEntity(
            id: shopId,
            name: name,
            storeImageURL: thumbnailImage,
            address: address,
            latitude: latitude,
            longitude: longitude,
            benefitCount: benefitCount
        )
    }
}
