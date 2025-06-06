//
//  SearchStoreEntity.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import CoreNetwork
import DesignSystem

public struct SearchStoreEntity {
    let id: Int
    let name: String
    let category: CategoryType
    let address: String
    let benefits: [StoreBenefitEntity]
}

public struct StoreBenefitEntity {
    let title: String
    let details: [String]
}

extension StoreListData {
    func toEntity() -> SearchStoreEntity {
        return SearchStoreEntity(
            id: shopId,
            name: name,
            category: CategoryType.from(category),
            address: address,
            benefits: benefitList.map { $0.toEntity() }
        )
    }
}

extension StoreBenefitData {
    func toEntity() -> StoreBenefitEntity {
        return StoreBenefitEntity(
            title: title,
            details: detailList
        )
    }
}
