//
//  DetailPartnershipEntity.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/28/25.
//

import Foundation
import CoreNetwork

public struct DetailPartnershipEntity {
    let name: String
    let institution: String
    let imageList: [String]
    let detail: String
    let snsLink: String
}

extension DetailPartnershipResponseDTO {
    func toEntity() -> DetailPartnershipEntity {
        return DetailPartnershipEntity(
            name: name,
            institution: institution,
            imageList: imageList,
            detail: detail,
            snsLink: snsLink
        )
    }
}
