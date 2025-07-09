//
//  SearchStoreRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct SearchStoreRequestDTO: QueryParameterConvertible {
    let university: String
    let category: String
    let latitude: String?
    let longitude: String?
    
    public init(
        university: String,
        category: String,
        latitude: String? = nil,
        longitude: String? = nil
    ) {
        self.university = university
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
    }
}
