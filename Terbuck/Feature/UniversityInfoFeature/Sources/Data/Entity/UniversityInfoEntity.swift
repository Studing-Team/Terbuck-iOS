//
//  UniversityInfoEntity.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 9/4/25.
//

import Foundation
import CoreNetwork

public struct UniversityInfoEntity {
    let id: Int
    let regionName: String
    let universityNames: [String]
}

extension UniversityInfoListResponseDTO {
    func toEntity() -> UniversityInfoEntity {

        let convertUniversityName = self.universities.map {
            $0.name
        }
        
        return UniversityInfoEntity(
            id: region.id,
            regionName: region.name,
            universityNames: convertUniversityName
        )
    }
}
