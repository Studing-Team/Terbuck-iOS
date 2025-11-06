//
//  UniversityInfoEntity.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation

public struct UniversityInfoEntity {
    public let id: Int
    public let regionName: String
    public let universityNames: [String]
    
    public init(id: Int, regionName: String, universityNames: [String]) {
        self.id = id
        self.regionName = regionName
        self.universityNames = universityNames
    }
}