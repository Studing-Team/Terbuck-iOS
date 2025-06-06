//
//  SearchPartnershipResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public struct SearchPartnershipResponseDTO: Decodable {
    public let list: [PartnershipListData]
}

public struct PartnershipListData: Decodable {
    public let id: Int
    public let name: String
    public let institution: String
    public let category: String
    
    public init(id: Int, name: String, institution: String, category: String) {
        self.id = id
        self.name = name
        self.institution = institution
        self.category = category
    }
}
