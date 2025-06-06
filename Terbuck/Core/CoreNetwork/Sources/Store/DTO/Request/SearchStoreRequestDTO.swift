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
    
    public init(university: String, category: String) {
        self.university = university
        self.category = category
    }
}
