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
    let benefitList: [SearchDetailStoreBenefitData]
    let usagesList: [SearchDetailStoreUsagesData]
}

public struct SearchDetailStoreBenefitData {
    let title: String
    let detailList: [String]
}

public struct SearchDetailStoreUsagesData {
    let usagesTitle: String
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
                SearchDetailStoreBenefitData(title: $0.title, detailList: $0.detailList)
            },
            usagesList: usagesList.map { SearchDetailStoreUsagesData(usagesTitle: $0.introduction) }
        )
    }
}
