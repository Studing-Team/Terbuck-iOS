//
//  CollegesInfoEntity.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation

public struct CollegesInfoEntity {
    public let id: Int
    public let collegeName: String
    
    public init(id: Int, collegeName: String) {
        self.id = id
        self.collegeName = collegeName
    }
}