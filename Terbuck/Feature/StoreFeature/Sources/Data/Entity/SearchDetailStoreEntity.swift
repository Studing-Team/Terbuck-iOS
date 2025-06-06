//
//  SearchDetailStoreEntity.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 6/4/25.
//

import Foundation
import CoreNetwork

public struct SearchDetailStoreEntity {
    let storeName: String
    let storeURL: String
    let storeImageURL: [String]
    let address: String
    let benefitCount: Int
    let benefitList: [SearchDetailStroeBenefitData]
}

public struct SearchDetailStroeBenefitData {
    let title: String
    let detailList: [String]
}

extension SearchStoreDetailResponseDTO {
    func toEntity() -> SearchDetailStoreEntity {
        return SearchDetailStoreEntity(
            storeName: name,
            storeURL: shopLink,
            storeImageURL: imageList,
            address: address,
            benefitCount: benefitCount,
            benefitList: benefitList.map {
                SearchDetailStroeBenefitData(title: $0.title, detailList: $0.detailList)
            }
        )
    }
}
