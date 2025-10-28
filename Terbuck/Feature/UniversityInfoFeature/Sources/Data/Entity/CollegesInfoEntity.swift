//
//  CollegesInfoEntity.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 9/23/25.
//

import Foundation
import CoreNetwork

public struct CollegesInfoEntity {
    let id: Int
    let collegeName: String
}

extension CollegesInfoResponseDTO {
    func toEntity() -> CollegesInfoEntity {
        return CollegesInfoEntity(id: id, collegeName: name)
    }
}
