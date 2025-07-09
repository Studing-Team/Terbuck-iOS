//
//  SearchStoreMapRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 5/29/25.
//

import Foundation

public struct SearchStoreMapRequestDTO: QueryParameterConvertible {
    let university: String
    let category: String
    let latitude: String
    let longitude: String
    
    public init(university: String, category: String, latitude: String, longitude: String) {
        self.university = university
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
    }
}
