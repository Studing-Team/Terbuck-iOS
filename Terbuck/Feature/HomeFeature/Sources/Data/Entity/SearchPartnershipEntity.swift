//
//  SearchPartnershipEntity.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/28/25.
//

import Foundation
import CoreNetwork

public struct SearchPartnershipEntity {
    let id: Int
    let name: String
    let institution: String
    let category: String
}

extension PartnershipListData {
    func toEntity() -> SearchPartnershipEntity {
        return SearchPartnershipEntity(
            id: id,
            name: name,
            institution: institution,
            category: category
        )
    }
}
