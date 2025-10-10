//
//  ChangeUniversityRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct ChangeUniversityRequestDTO: Encodable {
    let university: String
    let collegeId: Int
    
    public init(university: String, collegeId: Int) {
        self.university = university
        self.collegeId = collegeId
    }
}
