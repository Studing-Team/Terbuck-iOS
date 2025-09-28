//
//  CurrentVersionRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/25/25.
//

import Foundation

public struct CurrentVersionRequestDTO: QueryParameterConvertible {
    public let os: String
    
    init(os: String = "IOS") {
        self.os = os
    }
}
