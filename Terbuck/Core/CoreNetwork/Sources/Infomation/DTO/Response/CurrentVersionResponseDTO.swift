//
//  CurrentVersionResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/25/25.
//

import Foundation

public struct CurrentVersionResponseDTO: Decodable{
    public let os: String
    public let version: String
    
    public init(os: String, version: String) {
        self.os = os
        self.version = version
    }
}
