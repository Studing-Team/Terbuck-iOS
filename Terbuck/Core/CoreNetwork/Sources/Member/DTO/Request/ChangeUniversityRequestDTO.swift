//
//  ChangeUniversityRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct ChangeUniversityRequestDTO: Encodable {
    let university: String
    
    public init(university: String) {
        self.university = university
    }
}
