//
//  CollegesInfoResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/23/25.
//

import Foundation

public struct CollegesInfoResponseDTO: Decodable {
    public let id: Int
    public let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
